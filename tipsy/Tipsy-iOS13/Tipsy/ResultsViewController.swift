//
//  ResultsViewController 2.swift
//  Tipsy
//
//  Created by Adrian Gutierrez on 24/10/25.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    // Datos recibidos
    var billAmount: Double?
    var tipAmount: Double?
    var totalAmount: Double?

    // Outlets: etiquetas en la segunda pantalla
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Formatear a 2 decimales
        let fmt: (Double?) -> String = { value in
            guard let v = value else { return "—" }
            return String(format: "%.2f", v)
        }

        amountLabel.text = "Monto: $\(fmt(billAmount))"
        tipLabel.text = "Propina: $\(fmt(tipAmount))"
        totalLabel.text = "Total a pagar: $\(fmt(totalAmount))"
    }

    @IBAction func recalculatePressed(_ sender: UIButton) {
        // Volver a la pantalla anterior
        dismiss(animated: true, completion: nil)
    }
}

