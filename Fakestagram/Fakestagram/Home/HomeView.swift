//
//  HomeView.swift
//  Fakestagram
//
//  Created by Adrian Gutierrez on 08/11/25.
//
import UIKit

class HomeView: UIView {

    lazy var imageType: UISwitch = {
        let uiSwitch = UISwitch()
        return uiSwitch
    }()
    
    lazy var captionSwitch = UISwitch()
    
    lazy var customTextSwitch = UISwitch()
    
    lazy var picsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pics", for: .normal)
        var configuration = UIButton.Configuration.filled()
        configuration.background.backgroundColor = .accent
        configuration.baseForegroundColor = .systemBackground
        button.configuration = configuration
        
        return button
    }()
    
    lazy var customTextField = UITextView()
    
    private lazy var stackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 32
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return stackView
    }()
    
    private func createCaptionConfiguration() -> UIStackView {
        let stackView = createHorizontalStack()
        stackView.addArrangedSubview(createBasicLabel(text: "With caption", useTamic: false))
        stackView.addArrangedSubview(captionSwitch)
        return stackView
    }
    
    private func addConfigurationsToContainer() {
        stackViewContainer.addArrangedSubview(createImageTypeConfiguration())
        stackViewContainer.addArrangedSubview(createCaptionConfiguration())
        stackViewContainer.addArrangedSubview(createCustomTextConfiguration())
        stackViewContainer.addArrangedSubview(picsButton)
    }
    
    private func addConfigurationsToContainer() {
        addSubview(stackViewContainer)
        NSLayoutConstraint.activate([
            stackViewContainer.topAnchor.constraint(equalTo: topAnchor),
            stackViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackViewContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func createBasicLabel(text: String, useTamic: Bool) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = useTamic
        label.text = text
        return label
    }
    
    private func createHorizontalStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }
    
    private func createImageTypeConfiguration() -> UIStackView {
        let stackView = createHorizontalStack()
        let catLabel = createBasicLabel(text: "Cat", useTamic: false)
        catLabel.textAlignment = .center
        let dogLabel = createBasicLabel(text: "Dog", useTamic: false)
        dogLabel.textAlignment = .center
        stackView.addArrangedSubview(catLabel)
        stackView.addArrangedSubview(imageType)
        stackView.addArrangedSubview(dogLabel)
        dogLabel.widthAnchor.constraint(equalTo: catLabel.widthAnchor).isActive = true
        return stackView
     }
    
    private func setStackViewContainer(){
        addSubview(stackViewContainer)
        NSLayoutConstraint.activate([
            stackViewContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackViewContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackViewContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackViewContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

