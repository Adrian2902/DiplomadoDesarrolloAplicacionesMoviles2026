//
//  GameConfig.swift
//  RockPaperScisors
//
//  Created by Adrian Gutierrez on 14/11/25.
//

import Foundation

struct GameConfig {
    enum Mode {
        case rounds(Int)
        case points(win: Int, lose: Int, target: Int)
    }
    let playerName: String
    let mode: Mode
}

