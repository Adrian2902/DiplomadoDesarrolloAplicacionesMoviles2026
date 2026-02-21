//
//  LoginViewController.swift
//  Fakestagram
//
//  Created by Adrian Gutierrez on 11/10/25.
//

import UIKit

final class LoginViewController: UIViewController {
    

    var customView: LoginView {
        return view as! LoginView
    }
    
    override func loadView() {
        view = LoginView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func logIn(){
        let homeViewController = HomeViewController(nibName: "HomeView", bundle: nil)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .flipHorizontal
        navigationController.navigationBar.prefersLargeTitles = true
        present(navigationController, animated: true)
    }
}

