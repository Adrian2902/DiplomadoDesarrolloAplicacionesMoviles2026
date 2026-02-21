//
//  EntryDetailViewController.swift
//  DiaryApp
//
//  Created by Adrian Gutierrez on 30/01/26.
//

import UIKit
import MapKit
import Lottie
import CoreLocation

class EntryDetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let viewModel: EntryDetailViewModel
    private let locationManager = CLLocationManager()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let lottieView: LottieAnimationView = {
        let view = LottieAnimationView(name: "animation")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let messageLabel = UILabel()
    private let imageView = UIImageView()
    
    private let locationLabel = UILabel()
    private let mapView = MKMapView()
    private let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Caminando", "Conduciendo"])
        sc.selectedSegmentIndex = 1
        return sc
    }()
    
    private let directionsButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Obtener Ruta", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    init(viewModel: EntryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit))
        
        setupUI()
        configureData()
        setupLocation()
        
        lottieView.play()
        
        directionsButton.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        segmentControl.addTarget(self, action: #selector(updateRoute), for: .valueChanged)
    }
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    @objc private func didTapEdit() {
        let editorVM = EntryEditorViewModel(existingEntry: viewModel.entry)
        let editorVC = EntryEditorViewController(viewModel: editorVM)
        navigationController?.pushViewController(editorVC, animated: true)
    }
    
    @objc private func updateRoute() {
        getDirections()
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let stack = UIStackView(arrangedSubviews: [
            lottieView, titleLabel, dateLabel, messageLabel, imageView, locationLabel, segmentControl, directionsButton, mapView
        ])
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        
        dateLabel.textColor = .secondaryLabel
        messageLabel.textColor = .label
        messageLabel.numberOfLines = 0
        
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        lottieView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        mapView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureData() {
        let entry = viewModel.entry
        titleLabel.text = entry.title
        dateLabel.text = DateFormatter.localizedString(from: entry.date, dateStyle: .long, timeStyle: .short)
        messageLabel.text = entry.message
        
        if let img = viewModel.image {
            imageView.image = img
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }
        
        if let location = entry.location {
            locationLabel.text = "\(location.name)"
            locationLabel.isHidden = false
            segmentControl.isHidden = false
            directionsButton.isHidden = false
            mapView.isHidden = false

            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.name
            mapView.addAnnotation(annotation)

            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(region, animated: false)
        } else {
            locationLabel.isHidden = true
            segmentControl.isHidden = true
            directionsButton.isHidden = true
            mapView.isHidden = true
        }
    }
    
    @objc private func getDirections() {

        guard let destLoc = viewModel.entry.location else { return }
        let destinationCoordinate = destLoc.coordinate

        guard let sourceCoordinate = mapView.userLocation.location?.coordinate ?? locationManager.location?.coordinate else {
            showErrorAlert(message: "El GPS no responde. Por favor:\n1. Ve a Features > Location > None\n2. Espera 2 seg\n3. Ve a Features > Location > Custom Location")
            return
        }

        directionsButton.isEnabled = false
        directionsButton.setTitle("Calculando...", for: .normal)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.transportType = segmentControl.selectedSegmentIndex == 0 ? .walking : .automobile
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [weak self] response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.directionsButton.isEnabled = true
                self.directionsButton.setTitle("Obtener Ruta", for: .normal)

                if let error = error {
                    self.showErrorAlert(message: "Error de Apple Maps: \(error.localizedDescription)")
                    return
                }
                
                guard let route = response?.routes.first else {
                    self.showErrorAlert(message: "No se encontró ruta entre estos dos puntos.")
                    return
                }

                self.mapView.removeOverlays(self.mapView.overlays)
                self.mapView.addOverlay(route.polyline)

                let mapRect = route.polyline.boundingMapRect
                self.mapView.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Map Delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
}
