//
//  EntryEditorViewController.swift
//  DiaryApp
//
//  Created by Adrian Gutierrez on 30/01/26.
//

import UIKit
import PhotosUI

class EntryEditorViewController: UIViewController, LocationSearchDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate {
    
    var viewModel: EntryEditorViewModel

    private let titleField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Título"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .secondarySystemBackground
        tf.textColor = .label
        return tf
    }()
    
    private let messageView: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 8
        tv.font = .systemFont(ofSize: 16)
        tv.backgroundColor = .secondarySystemBackground
        tv.textColor = .label
        return tv
    }()
    
    private let locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sin ubicación"
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemGray6
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    init(viewModel: EntryEditorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.entry.isDraft ? "Nueva Entrada" : "Editar Entrada"
        
        setupUI()
        populateData()

        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [titleField, locationLabel, messageView, imageView])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        let photoBtn = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(didTapPhoto))
        let locBtn = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action: #selector(didTapLocation))
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        
        navigationItem.rightBarButtonItems = [saveBtn, locBtn, photoBtn]
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            messageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func populateData() {
        titleField.text = viewModel.entry.title
        messageView.text = viewModel.entry.message
        if let loc = viewModel.entry.location {
            locationLabel.text = "📍 \(loc.name)"
        }
        imageView.image = viewModel.selectedImage
    }
    
    // MARK: - Actions
    @objc private func didTapSave() {
       
        viewModel.save(title: titleField.text ?? "", message: messageView.text ?? "", isDraft: false) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func appWillResignActive() {
        
        viewModel.save(title: titleField.text ?? "", message: messageView.text ?? "", isDraft: true) {
            debugPrint("Borrador guardado automáticamente")
        }
    }
    
    @objc private func didTapLocation() {
        let searchVC = LocationSearchViewController()
        searchVC.delegate = self
        present(searchVC, animated: true)
    }
    
    @objc private func didTapPhoto() {
        let alert = UIAlertController(title: "Seleccionar Foto", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Cámara", style: .default) { _ in
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Galería", style: .default) { _ in
            var config = PHPickerConfiguration()
            config.filter = .images
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self.present(picker, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - Delegates
    func didSelectLocation(_ location: Location) {
        viewModel.updateLocation(location)
        locationLabel.text = "📍 \(location.name)"
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            DispatchQueue.main.async {
                if let uiImage = image as? UIImage {
                    self?.viewModel.selectedImage = uiImage
                    self?.imageView.image = uiImage
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            viewModel.selectedImage = image
            imageView.image = image
        }
    }
}
