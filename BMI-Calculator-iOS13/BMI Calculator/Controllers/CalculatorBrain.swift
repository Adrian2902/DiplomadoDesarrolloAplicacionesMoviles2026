//
//  CalculatorBrain.swift
//  BMI Calculator
//
//

import UIKit

struct CalculatorBrain {
    
    var bmi: BMI?
    
    func getBMI() -> String {
        let bmiString = String(format: "%.1f", bmi?.value ?? 0.0)
        return bmiString
    }
    
    mutating func calculateBMI(height: Float, weight: Float){
        let bmiValue = weight/pow(height,2)
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "Bajo peso", color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
        } else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, advice: "Peso normal", color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        } else if bmiValue > 24.9 && bmiValue <= 29.9{
            bmi = BMI(value: bmiValue, advice: "Sobrepeso", color: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
        } else if bmiValue > 29.9 && bmiValue <= 34.9{
            bmi = BMI(value: bmiValue, advice: "Obesidad 1", color: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
        } else if bmiValue > 34.9 && bmiValue <= 39.9{
            bmi = BMI(value: bmiValue, advice: "Obesidad 2", color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        } else if bmiValue > 39.9 && bmiValue <= 49.9{
            bmi = BMI(value: bmiValue, advice: "Obesidad 3", color: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))
        } else {
            bmi = BMI(value: bmiValue, advice: "Obesidad 4", color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    func getAdvice() -> String{
        return bmi?.advice ?? "Advice"
    }
    
    func getColor() -> UIColor {
        return bmi?.color ?? #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    }
}
