//
//  GameViewController.swift
//  RockPaperScisors
//
//  Created by Adrian Gutierrez on 14/11/25.
//

import UIKit

class GameViewController: UIViewController {
    private let config: GameConfig

    private let statusLabel = UILabel()
    private let opponentLabel = UILabel()
    private let scoreLabel = UILabel()
    private let stack = UIStackView()
    private var choiceButtons: [UIButton] = []
    private let nextTurnButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let historyButton = UIButton(type: .system)

    private var currentScore: Int = 0
    private var currentRoundsWon: Int = 0
    private var roundsToWin: Int? = nil
    private var pointsWin: Int = 0
    private var pointsLose: Int = 0
    private var targetPoints: Int = 0

    init(config: GameConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
        switch config.mode {
        case .rounds(let n):
            roundsToWin = n
        case .points(let win, let lose, let target):
            pointsWin = win
            pointsLose = lose
            targetPoints = target
        }
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(config:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        title = "Juego"
        setupUI()
        updateScoreLabel()
        statusLabel.text = "Turno de \(config.playerName)"
    }

    private func setupUI() {
        // Status label
        statusLabel.font = UIFont.boldSystemFont(ofSize: 20)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        opponentLabel.font = UIFont.systemFont(ofSize: 30)
        opponentLabel.textAlignment = .center
        view.addSubview(opponentLabel)
        opponentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            opponentLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            opponentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        scoreLabel.font = UIFont.systemFont(ofSize: 18)
        scoreLabel.textAlignment = .center
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: opponentLabel.bottomAnchor, constant: 8),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 12
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.heightAnchor.constraint(equalToConstant: 100)
        ])

        for choice in Choice.allCases {
            let btn = UIButton(type: .system)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 40)
            btn.setTitle(choice.emoji, for: .normal)
            btn.tag = choice.rawValue
            btn.addTarget(self, action: #selector(choiceTapped(_:)), for: .touchUpInside)
            choiceButtons.append(btn)
            stack.addArrangedSubview(btn)
        }
        
        nextTurnButton.setTitle("Siguiente Turno", for: .normal)
        nextTurnButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        nextTurnButton.addTarget(self, action: #selector(nextTurnTapped(_:)), for: .touchUpInside)
        nextTurnButton.isHidden = true

        resetButton.setTitle("Resetear", for: .normal)
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        resetButton.addTarget(self, action: #selector(resetTapped(_:)), for: .touchUpInside)

        historyButton.setTitle("Historial", for: .normal)
        historyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        historyButton.addTarget(self, action: #selector(historyTapped(_:)), for: .touchUpInside)

        let bottomStack = UIStackView(arrangedSubviews: [nextTurnButton, resetButton, historyButton])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.spacing = 12
        view.addSubview(bottomStack)
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomStack.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20),
            bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomStack.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func choiceTapped(_ sender: UIButton) {
        guard let playerChoice = Choice(rawValue: sender.tag) else { return }
        
        let opponentChoice = Choice.allCases.randomElement()!
        opponentLabel.text = "Oponente: \(opponentChoice.emoji)"

        let result = compare(playerChoice, opponentChoice)
        let resultText: String
        
        switch result {
        case .win:
            resultText = "¡Ganaste, \(config.playerName)!"
            view.backgroundColor = .systemGreen
            applyWin()
        case .lose:
            resultText = "Perdiste, \(config.playerName)."
            view.backgroundColor = .systemRed
            applyLose()
        case .tie:
            resultText = "Empate, \(config.playerName)."
            view.backgroundColor = .brown
        }
        
        statusLabel.text = resultText
        nextTurnButton.isHidden = false
        
        choiceButtons.forEach { $0.isEnabled = false }

        let round = GameRound(
            playerChoice: playerChoice,
            opponentChoice: opponentChoice,
            result: result,
            playerName: config.playerName
        )
        GameHistory.shared.addRound(round)
    }

    private func compare(_ player: Choice, _ opponent: Choice) -> GameResult {
        if player == opponent {
            return .tie
        } else if player.beats(opponent) {
            return .win
        } else {
            return .lose
        }
    }

    private func applyWin() {
        if let roundsToWin = roundsToWin {
            currentRoundsWon += 1
            updateScoreLabel()
            if currentRoundsWon >= roundsToWin {
                showVictoryAlert()
            }
        } else {
            currentScore += pointsWin
            updateScoreLabel()
            if currentScore >= targetPoints {
                showVictoryAlert()
            }
        }
    }

    private func applyLose() {
        if roundsToWin == nil {
            // Points mode only
            currentScore -= pointsLose
            if currentScore < 0 {
                currentScore = 0
            }
            updateScoreLabel()
        }
    }

    private func updateScoreLabel() {
        if let roundsToWin = roundsToWin {
            scoreLabel.text = "Rondas ganadas: \(currentRoundsWon) / \(roundsToWin)"
        } else {
            scoreLabel.text = "Puntos: \(currentScore) / \(targetPoints)"
        }
    }

    @objc private func nextTurnTapped(_ sender: UIButton) {
        // Reset visuals for next turn
        view.backgroundColor = .systemGray4
        statusLabel.text = "Turno de \(config.playerName)"
        opponentLabel.text = ""
        nextTurnButton.isHidden = true
        
        // Re-enable choice buttons
        choiceButtons.forEach { $0.isEnabled = true }
    }

    @objc private func resetTapped(_ sender: UIButton) {
        currentScore = 0
        currentRoundsWon = 0
        GameHistory.shared.clear()
        updateScoreLabel()
        view.backgroundColor = .systemGray4
        statusLabel.text = "Juego reiniciado. Turno de \(config.playerName)"
        opponentLabel.text = ""
        nextTurnButton.isHidden = true
        choiceButtons.forEach { $0.isEnabled = true }
    }

    @objc private func historyTapped(_ sender: UIButton) {
        let histVC = HistoryViewController()
        navigationController?.pushViewController(histVC, animated: true)
    }

    private func showVictoryAlert() {
        let ac = UIAlertController(
            title: "¡Victoria!",
            message: "\(config.playerName) ganó la sesión",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
