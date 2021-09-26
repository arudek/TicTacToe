//
//  Board.swift
//  TicTacToe
//
//  Created by Arne Rudek on 26.09.21.
//

import UIKit
import GameplayKit

enum TTTSymbol: Int {
    case none = 0
    case circle
    case cross
}

class Board: NSObject, GKGameModel {
    var fields = [TTTSymbol]()
    var players: [GKGameModelPlayer]?
    var activePlayer: GKGameModelPlayer?
    
    var currentPlayer: Player? {
        activePlayer as? Player
    }
    var opponent: Player? {
        guard let activePlayer = activePlayer as? Player else { return nil }
        
        return opponent(for: activePlayer)
    }
    
    func opponent(for player: Player) -> Player? {
        guard let players = players else { return nil }
        
        return players.filter { $0.playerId != player.playerId }
            .first as? Player
    }
    
    override init() {
        for _ in 0 ..< 9 {
            fields.append(.none)
        }
        
        /// evtl. an anderer Stelle initialisieren
        players = [Player(symbol: .circle), Player(symbol: .cross)]
        activePlayer = players?[0]
        /// ende Initialisierung
        
        super.init()
    }
    
    /// Für AI
    
    /// Kopiert das Model
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        copy.setGameModel(self)
        return copy
    }
    
    /// Spielt eine Kopie des Models zurück
    func setGameModel(_ gameModel: GKGameModel) {
        if let board = gameModel as? Board {
            fields = board.fields
            players = board.players
            activePlayer = board.activePlayer
        }
    }
    
    /// List mit möglichen Zügen für einen Spieler
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        
        if let player = player as? Player,
        let opponent = opponent(for: player) {
            if isWin(for: player) || isWin(for: opponent) {
                return nil
            }
            
            var moves = [Move]()
            for column in 0 ..< 3 {
                for row in 0 ..< 3 {
                    if canMove(column: column, row: row) {
                        moves.append(Move(column: column, row: row))
                    }
                }
            }
            return moves
        }
        
        return nil
    }
    
    /// Spielzug ausführen
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard let currentPlayer = currentPlayer else { return }

        if let move = gameModelUpdate as? Move {
            fields[move.column * 3 + move.row] = currentPlayer.symbol
            self.activePlayer = self.opponent
        }
    }
    
    /// Ende AI
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        let sym = (player as! Player).symbol
        let horizontal =
        (fields[0] == sym && fields[3] == sym && fields[6] == sym) ||
        (fields[1] == sym && fields[4] == sym && fields[7] == sym) ||
        (fields[2] == sym && fields[5] == sym && fields[8] == sym)
        let vertical =
        (fields[0] == sym && fields[1] == sym && fields[2] == sym) ||
        (fields[3] == sym && fields[4] == sym && fields[5] == sym) ||
        (fields[6] == sym && fields[7] == sym && fields[8] == sym)
        let diagonal =
        (fields[0] == sym && fields[4] == sym && fields[8] == sym) ||
        (fields[2] == sym && fields[4] == sym && fields[6] == sym)
        
        return horizontal || vertical || diagonal
    }
    
    func canMove(column: Int, row: Int) -> Bool {
        return fields[column * 3 + row] == .none
    }
}
