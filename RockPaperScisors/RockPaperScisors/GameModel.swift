//
//  GameModel.swift
//  RockPaperScisors
//
//  Created by Adrian Gutierrez on 14/11/25.
//

import Foundation

enum Choice: Int, CaseIterable {
    case rock = 0
    case paper = 1
    case scissors = 2
    
    var emoji: String {
        switch self {
        case .rock: return "🪨"
        case .paper: return "📄"
        case .scissors: return "✂️"
        }
    }
    
    func beats(_ other: Choice) -> Bool {
        switch (self, other) {
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
            return true
        default:
            return false
        }
    }
}

enum GameResult {
    case win, lose, tie
}

struct GameRound {
    let playerChoice: Choice
    let opponentChoice: Choice
    let result: GameResult
    let playerName: String
}

class GameHistory {
    static let shared = GameHistory()
    private(set) var rounds: [GameRound] = []
    
    private init() {}
    
    func addRound(_ round: GameRound) {
        rounds.append(round)
    }
    
    func clear() {
        rounds.removeAll()
    }
    
    func getHistoryText() -> String {
        guard !rounds.isEmpty else {
            return "No hay historial de juegos aún."
        }
        
        var text = "HISTORIAL DE JUEGOS\n"
        text += "===================\n\n"
        
        for (index, round) in rounds.enumerated() {
            text += "Ronda \(index + 1):\n"
            text += "Jugador (\(round.playerName)): \(round.playerChoice.emoji)\n"
            text += "Oponente: \(round.opponentChoice.emoji)\n"
            
            switch round.result {
            case .win:
                text += "Resultado: ¡\(round.playerName) GANÓ! 🎉\n"
            case .lose:
                text += "Resultado: \(round.playerName) perdió 😢\n"
            case .tie:
                text += "Resultado: Empate 🤝\n"
            }
            text += "\n"
        }
        
        return text
    }
}
