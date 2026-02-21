//
//  UIViewController+Ext.swift
//  GitApp
//
//  Created by Adrian Gutierrez on 15/01/26.
//

import UIKit

extension UIViewController {
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String = "Ok") {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default))
            self.present(alertVC, animated: true)
        }
    }
}
