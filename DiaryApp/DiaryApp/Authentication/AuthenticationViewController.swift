//
//  AuthenticationViewController.swift
//  DiaryApp
//
//  Created by Adrian Gutierrez on 30/01/26.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    private let viewModel = AuthenticationViewModel()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Mi Diario"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Autenticar", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground 
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.addSubview(logoLabel)
        view.addSubview(authButton)
        
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            authButton.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 40),
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButton.widthAnchor.constraint(equalToConstant: 200),
            authButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        authButton.addTarget(self, action: #selector(didTapAuth), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.onAuthSuccess = { [weak self] in
            guard let self = self else { return }

            let listVC = DiaryListTableViewController()
            let nav = UINavigationController(rootViewController: listVC)
            nav.modalPresentationStyle = .fullScreen
            
            if let window = self.view.window {
                window.rootViewController = nav
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
        
        viewModel.onAuthError = { errorMsg in
            debugPrint(errorMsg)
        }
    }
    
    @objc private func didTapAuth() {
        viewModel.authenticate()
    }
}
