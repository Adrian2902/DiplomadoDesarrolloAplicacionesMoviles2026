//
//  ViewController.swift
//  EjercicioEncuesta
//
//  Created by Adrian Gutierrez on 24/10/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var actividadOcioText: UITextField!
    @IBOutlet weak var futbolSwitch: UISwitch!
    @IBOutlet weak var comidaSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sendAnswersButton: UIButton!
    
    
    // Devuelve el índice seleccionado (o noSegment si no hay selección)
    private var selectedFoodIndex: Int? {
        let idx = comidaSegmentedControl.selectedSegmentIndex
        return idx != UISegmentedControl.noSegment ? idx : nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Asegurarnos de que no haya selección por defecto
        comidaSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment

        // Botón inicialmente deshabilitado
        sendAnswersButton.isEnabled = false
        sendAnswersButton.alpha = 0.5

        // Observadores de cambios
        comidaSegmentedControl.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)
        actividadOcioText.addTarget(self, action: #selector(controlValueChanged), for: .editingChanged)

        // Delegado para cerrar teclado al pulsar Return
        actividadOcioText.delegate = self
    }

    @objc func controlValueChanged() {
        validateForm()
    }

    private func validateForm() {
        let hasSelectedFood = (comidaSegmentedControl.selectedSegmentIndex != UISegmentedControl.noSegment)
        let ocioText = actividadOcioText.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let hasOcioText = !ocioText.isEmpty

        let enable = hasSelectedFood && hasOcioText
        sendAnswersButton.isEnabled = enable
        sendAnswersButton.alpha = enable ? 1.0 : 0.5
    }

    @IBAction func sendAnswersButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showResults", sender: nil)
    }

    // Pasar datos al ResultsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults",
            let resultsVC = segue.destination as? AnswersViewController {
            resultsVC.favoriteFoodIndex = comidaSegmentedControl.selectedSegmentIndex
            resultsVC.likesFootball = futbolSwitch.isOn
            resultsVC.favoriteLeisure = actividadOcioText.text ?? ""
        }
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

