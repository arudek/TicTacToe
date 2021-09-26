//
//  Player.swift
//  TicTacToe
//
//  Created by Arne Rudek on 26.09.21.
//

import UIKit
import GameplayKit

class Player: NSObject, GKGameModelPlayer {
    let playerId: Int
    let symbol: TTTSymbol
    var name: String
    var score: Int = 0
    
    init(symbol: TTTSymbol) {
        self.symbol = symbol
        self.playerId = symbol.rawValue
        self.name = "Player \(playerId)"
    }
}
