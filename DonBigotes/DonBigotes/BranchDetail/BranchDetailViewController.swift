//
//  BranchDetailViewController.swift
//  DonBigotes
//
//  Created by Adrian Gutierrez on 23/01/26.
//

import UIKit
import MapKit

class BranchDetailViewController: UIViewController {
    
    private let viewModel: BranchDetailViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 12
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 24)
        lbl.numberOfLines = 0
        lbl.textColor = .label
        return lbl
    }()
    
    private let addressLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let phoneLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = .systemBlue
        return lbl
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    init(branch: Branch) {
        self.viewModel = BranchDetailViewModel(branch: branch)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMap()
        populateData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Detalle"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
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
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])

        stackView.addArrangedSubview(mapView)
        mapView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(phoneLabel)

        let separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.addArrangedSubview(separator)

        let hoursHeader = UILabel()
        hoursHeader.text = "Horarios"
        hoursHeader.font = .boldSystemFont(ofSize: 18)
        stackView.addArrangedSubview(hoursHeader)
    }
    
    private func populateData() {
        nameLabel.text = viewModel.name
        addressLabel.text = viewModel.address
        phoneLabel.text = viewModel.phone

        for schedule in viewModel.formattedHours {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            
            let dayLbl = UILabel()
            dayLbl.text = schedule.day
            dayLbl.font = .systemFont(ofSize: 15, weight: .medium)
            
            let hourLbl = UILabel()
            hourLbl.text = schedule.hours
            hourLbl.font = .systemFont(ofSize: 15)
            hourLbl.textColor = .secondaryLabel
            hourLbl.textAlignment = .right
            
            row.addArrangedSubview(dayLbl)
            row.addArrangedSubview(hourLbl)
            stackView.addArrangedSubview(row)
        }

        let space = UIView()
        space.heightAnchor.constraint(equalToConstant: 10).isActive = true
        stackView.addArrangedSubview(space)
        
        let servicesHeader = UILabel()
        servicesHeader.text = "Servicios"
        servicesHeader.font = .boldSystemFont(ofSize: 18)
        stackView.addArrangedSubview(servicesHeader)
        
        let servicesContent = UILabel()
        servicesContent.text = "• " + viewModel.servicesList
        servicesContent.numberOfLines = 0
        servicesContent.textColor = .secondaryLabel
        stackView.addArrangedSubview(servicesContent)
    }
    
    private func setupMap() {
        let location = CLLocationCoordinate2D(
            latitude: viewModel.branch.location.latitude,
            longitude: viewModel.branch.location.longitude
        )
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = viewModel.name
        
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: false)
    }
}
