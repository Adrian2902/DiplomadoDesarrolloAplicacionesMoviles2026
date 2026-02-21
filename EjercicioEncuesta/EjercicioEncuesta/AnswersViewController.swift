//
//  AnswersViewController.swift
//  EjercicioEncuesta
//
//  Created by Adrian Gutierrez on 24/10/25.
//

import UIKit

class AnswersViewController: UIViewController {

    @IBOutlet weak var ocioAnswerText: UITextField!
    @IBOutlet weak var futbolAnswerSwitch: UISwitch!
    @IBOutlet weak var comidaAnswerSegmentedControl: UISegmentedControl!
    
    // Propiedades que serán asignadas desde SurveyViewController
    var favoriteFoodIndex: Int?
    var likesFootball: Bool = false
    var favoriteLeisure: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Mostrar la respuesta de ocio en el textField (no editable)
        ocioAnswerText.text = favoriteLeisure ?? ""
        ocioAnswerText.isEnabled = false

        // Mostrar switch (y deshabilitar interacción)
        futbolAnswerSwitch.isOn = likesFootball
        futbolAnswerSwitch.isEnabled = false

        // Seleccionar el segmento correspondiente y deshabilitar interacción
        if let idx = favoriteFoodIndex,
            idx != UISegmentedControl.noSegment,
            idx >= 0 && idx < comidaAnswerSegmentedControl.numberOfSegments {
            comidaAnswerSegmentedControl.selectedSegmentIndex = idx
        } else {
            comidaAnswerSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        }
        comidaAnswerSegmentedControl.isEnabled = false
    }
}
