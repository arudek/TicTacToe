//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Arne Rudek on 26.09.21.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    @State var board = Board()
    var body: some Scene {
        WindowGroup {
            MainView(board: board)
        }
    }
}
