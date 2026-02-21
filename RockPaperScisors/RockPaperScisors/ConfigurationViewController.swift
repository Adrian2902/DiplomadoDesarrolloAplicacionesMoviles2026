//
//  ConfigurationViewController.swift
//  RockPaperScisors
//
//  Created by Adrian Gutierrez on 14/11/25.
//

import UIKit

class ConfigurationViewController: UIViewController {

    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var roundsContainerView: UIView!
    @IBOutlet weak var roundsLabel: UILabel!
    @IBOutlet weak var roundsSlider: UISlider!
    @IBOutlet weak var pointsContainerView: UIView!
    @IBOutlet weak var winPointsTextField: UITextField!
    @IBOutlet weak var losePointsTextField: UITextField!
    @IBOutlet weak var targetScoreTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Configuración"
        roundsSlider.minimumValue = 1
        roundsSlider.maximumValue = 5
        roundsSlider.value = 1
        roundsLabel.text = "Rondas: \(Int(roundsSlider.value))"
        updateUIForMode()
        continueButton.isHidden = true
        addTargets()
        playerNameTextField.delegate = self
        winPointsTextField.delegate = self
        losePointsTextField.delegate = self
        targetScoreTextField.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func addTargets() {
        playerNameTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        winPointsTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        losePointsTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        targetScoreTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
    }

    private func updateUIForMode() {
        let byRounds = (modeSegmentedControl.selectedSegmentIndex == 0)
        roundsContainerView.isHidden = !byRounds
        pointsContainerView.isHidden = byRounds
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func textChanged(_ sender: Any) {
        validateForm()
    }

    private func validateForm() {
        let name = (playerNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else {
            continueButton.isHidden = true
            return
        }
        if modeSegmentedControl.selectedSegmentIndex == 0 {
            continueButton.isHidden = false
        } else {
            guard
                let winText = winPointsTextField.text, let win = Int(winText),
                let loseText = losePointsTextField.text, let _ = Int(loseText),
                let targetText = targetScoreTextField.text, let target = Int(targetText)
            else {
                continueButton.isHidden = true
                return
            }

            if win > 0 && target > 0 && target >= win {
                continueButton.isHidden = false
            } else {
                continueButton.isHidden = true
            }
        }
    }

    @IBAction func modeChanged(_ sender: UISegmentedControl) {
        updateUIForMode()
        validateForm()
    }

    @IBAction func roundsSliderChanged(_ sender: UISlider) {
        let value = Int(sender.value.rounded())
        sender.value = Float(value)
        roundsLabel.text = "Rondas: \(value)"
        validateForm()
    }

    @IBAction func continueTapped(_ sender: UIButton) {
        let playerName = (playerNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if playerName.isEmpty { return }

        let config: GameConfig
        if modeSegmentedControl.selectedSegmentIndex == 0 {
            let rounds = Int(roundsSlider.value)
            config = GameConfig(playerName: playerName, mode: .rounds(rounds))
        } else {
            let win = Int(winPointsTextField.text ?? "") ?? 0
            let lose = Int(losePointsTextField.text ?? "") ?? 0
            let target = Int(targetScoreTextField.text ?? "") ?? 0
            config = GameConfig(playerName: playerName, mode: .points(win: win, lose: lose, target: target))
        }

        let gameVC = GameViewController(config: config)
        navigationController?.pushViewController(gameVC, animated: true)
    }

    @IBAction func infoTapped(_ sender: UIBarButtonItem) {
        let infoVC = InformationViewController(nibName: "InformationView", bundle: nil)
        present(infoVC, animated: true)
    }
}

extension ConfigurationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == playerNameTextField {
            if modeSegmentedControl.selectedSegmentIndex == 1 {
                winPointsTextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
