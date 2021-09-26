//
//  MainView.swift
//  TicTacToe
//
//  Created by Arne Rudek on 26.09.21.
//

import SwiftUI
import GameplayKit

extension MainView {
    class ViewModel: ObservableObject {
        var strategist: GKMinmaxStrategist!
        
        init() {
            strategist = GKMinmaxStrategist()
            strategist.maxLookAheadDepth = 10
            /// ersten Zug nehmen, wenn mehrere gleich gut sind
            strategist.randomSource = nil
            /// zufällig einen der gleich guten Züge wählen
    //        strategist.randomSource = GKARC4RandomSource
        }
    }
}

struct MainView: View {
    @ObservedObject var board: Board
    @State var viewModel = ViewModel()

    
    init(board: Board) {
        self.board = board
        self.viewModel.strategist.gameModel = board
    }
    
    func makeAiMove() {
        if let player = board.activePlayer,
           let aiMove = viewModel.strategist.bestMove(for: player) as? Move {
            board.apply(aiMove)
        }
    }
    
    var body: some View {
        VStack {
            Text("Tic Tac Toe")
                .font(.title)
                .padding()
            
            if board.isEnded() == .playing,
                let currPlayer = board.currentPlayer,
               currPlayer.symbol == .circle {
                Text("Du bist dran...")
            }
            Spacer()
            ZStack {
                gameFields

                let ended = board.isEnded()
                if ended != .playing {
                    VStack {
                        switch ended {
                        case .draw:
                            Text("Unentschieden")
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color.black)
                        case .ended(let winner):
                            Text("\(winner.name) hat gewonnen!")
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color.black)
                        default:
                            EmptyView()
                        }
                        
                        Button {
                            board.reset()
                        } label: {
                            Text("Neues Spiel")
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color.black)
                        }
                    }
                }
            }
            Spacer()
        }
    }
    
    private var gameFields: some View {
        VStack(spacing: 2) {
            ForEach(0...2, id: \.self) { column in
                HStack(spacing: 2) {
                    ForEach(0...2, id: \.self) { row in
                        let emptyField = board.canMove(column: column, row: row)
                        Button {} label: {
                            let sym = board.getSymbol(column: column, row: row)
                            if sym != .none {
                                let symbName = sym == .circle ? "circle" : "multiply"
                                Image(systemName: symbName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(emptyField ? Color.gray : Color.white)
                        .foregroundColor(Color.black)
                        .onTapGesture {
                            if emptyField {
                                board.setSymbol(column: column, row: row)
                                
                                self.makeAiMove()
                            }
                        }
                    }
                }
            }
        }
        .background(Color.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(board: Board())
    }
}
