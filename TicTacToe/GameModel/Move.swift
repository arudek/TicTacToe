//
//  Move.swift
//  TicTacToe
//
//  Created by Arne Rudek on 26.09.21.
//

import UIKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var row: Int
    var column: Int
    
    init(column: Int, row: Int) {
        self.row = row
        self.column = column
    }
}
