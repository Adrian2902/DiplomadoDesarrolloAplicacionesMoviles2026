//
//  HistoryViewController.swift
//  RockPaperScisors
//
//  Created by Adrian Gutierrez on 14/11/25.
//

import UIKit

class HistoryViewController: UIViewController {
    
    private let historyTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Historial de Juegos"
        view.backgroundColor = .systemBackground
        setupHistoryView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHistory()
    }
    
    private func setupHistoryView() {
        historyTextView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        historyTextView.isEditable = false
        historyTextView.backgroundColor = .systemGray6
        historyTextView.layer.cornerRadius = 8
        historyTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        view.addSubview(historyTextView)
        historyTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            historyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            historyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            historyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            historyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func updateHistory() {
        historyTextView.text = GameHistory.shared.getHistoryText()
    }
}
