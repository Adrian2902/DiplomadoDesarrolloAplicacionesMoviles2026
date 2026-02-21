//
//  HomeViewController.swift
//  DonBigotes
//
//  Created by Adrian Gutierrez on 23/01/26.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sloganLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var branchesButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Ver Sucursales", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(didTapBranches), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadStoreInfo()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(sloganLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(branchesButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            sloganLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            sloganLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sloganLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            branchesButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            branchesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            branchesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            branchesButton.heightAnchor.constraint(equalToConstant: 50),
            branchesButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onDataLoaded = { [weak self] in
            guard let self = self else { return }
            self.nameLabel.text = self.viewModel.title
            self.sloganLabel.text = self.viewModel.slogan
            self.descriptionLabel.text = self.viewModel.description
            
            if let urlStr = self.viewModel.logoUrl, let url = URL(string: urlStr) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.logoImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
    
    @objc private func didTapBranches() {
        let listVC = BranchListViewController(branches: viewModel.branches)
        navigationController?.pushViewController(listVC, animated: true)
    }
}
