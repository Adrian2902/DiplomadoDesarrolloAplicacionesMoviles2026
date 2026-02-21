//
//  ViewController.swift
//  BMI Calculator
//
//

import UIKit

class CalculateViewController: UIViewController, UITextFieldDelegate {
    
    var calculatorBrain = CalculatorBrain()

//    @IBOutlet weak var heightLabel: UILabel!
//    @IBOutlet weak var weightLabel: UILabel!
//    @IBOutlet weak var heightSlider: UISlider!
//    @IBOutlet weak var weightSlider: UISlider!
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        heightTextField.delegate = self
        weightTextField.delegate = self
        
        calculateButton.isEnabled = false
        calculateButton.alpha = 0.5
                
                // Detectar cambios de texto
        heightTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        weightTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
            }
    
    @objc func textFieldsDidChange() {
            let heightText = heightTextField.text ?? ""
            let weightText = weightTextField.text ?? ""
            
            // Activa el botón solo si ambos tienen valores válidos
            if !heightText.isEmpty, !weightText.isEmpty,
               let _ = Float(heightText), let _ = Float(weightText) {
                calculateButton.isEnabled = true
                calculateButton.alpha = 1.0
            } else {
                calculateButton.isEnabled = false
                calculateButton.alpha = 0.5
            }
        }

//    @IBAction func heightSliderChanged(_ sender: UISlider) {
//        heightLabel.text = "\(String(format: "%.2f", sender.value))m"
//    }
//    
//    @IBAction func weightSliderChanged(_ sender: UISlider) {
//        weightLabel.text = "\(String(format: "%.0f", sender.value))Kg"
//    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        guard let heightText = heightTextField.text,
                      let weightText = weightTextField.text,
                      let height = Float(heightText),
                      let weight = Float(weightText) else {
                    return
                }
                
                calculatorBrain.calculateBMI(height: height, weight: weight)
                performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.bmiValue = calculatorBrain.getBMI()
            destinationVC.advice = calculatorBrain.getAdvice()
            destinationVC.color = calculatorBrain.getColor()
        }
    }
}

