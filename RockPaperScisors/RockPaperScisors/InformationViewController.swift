//
//  InformationViewController.swift
//  RockPaperScisors
//
//  Created by Adrian Gutierrez on 14/11/25.
//

import UIKit

class InformationViewController: UIViewController {
    @IBOutlet weak var rulesTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        rulesTextView.isEditable = false
        rulesTextView.text = """
        Reglas:
        - Piedra vence a tijeras.
        - Tijeras vence a papel.
        - Papel vence a piedra.
        
        Agradecimientos:
            Adrian Gutierrez
        """
    }

    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
