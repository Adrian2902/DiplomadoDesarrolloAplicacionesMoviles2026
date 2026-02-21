//
//  TypeDetailView.swift
//  pokedex
//
//  Created by Adrian Gutierrez on 28/11/25.
//

import UIKit

class TypeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let pokemonType: PokemonType
    let tableView = UITableView()
    
    struct TypeSection {
        let title: String
        let types: [String]
    }
    
    var sections: [TypeSection] = []
    
    init(type: PokemonType) {
        self.pokemonType = type
        super.init(nibName: nil, bundle: nil)
        
        sections = [
            TypeSection(title: "Double Damage Dealt (2x)", types: type.doubleDamageDealt),
            TypeSection(title: "Double Damage Received (2x)", types: type.doubleDamageReceived),
            TypeSection(title: "Half Damage Dealt (0.5x)", types: type.halfDamageDealt),
            TypeSection(title: "Half Damage Received (0.5x)", types: type.halfDamageReceived),
            TypeSection(title: "No Effect Against (0x)", types: type.noEffectAgainst),
            TypeSection(title: "Not Affected By (0x)", types: type.notAffectedBy)
        ]
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = pokemonType.name
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TypeCategoryCell.self, forCellReuseIdentifier: "TypeCategoryCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCategoryCell", for: indexPath) as! TypeCategoryCell
        let sectionData = sections[indexPath.row]
        cell.configure(title: sectionData.title, types: sectionData.types)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

class TypeCategoryCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let titleLabel = UILabel()
    var collectionView: UICollectionView!
    var typeNames: [String] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TypeSymbolCell.self, forCellWithReuseIdentifier: "TypeSymbolCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(title: String, types: [String]) {
        titleLabel.text = title
        self.typeNames = types
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if typeNames.isEmpty { return 1 }
        return typeNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeSymbolCell", for: indexPath) as! TypeSymbolCell
        
        if typeNames.isEmpty {
            cell.configure(imageName: nil, name: "None")
        } else {
            let name = typeNames[indexPath.item]
            let symbol = DataManager.shared.getSymbol(forTypeName: name)
            cell.configure(imageName: symbol, name: name)
        }
        
        return cell
    }
}

class TypeSymbolCell: UICollectionViewCell {
    let symbolImageView = UIImageView()
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 25
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        
        symbolImageView.contentMode = .scaleAspectFit
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(symbolImageView)
        
        nameLabel.font = .systemFont(ofSize: 10)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            container.widthAnchor.constraint(equalToConstant: 50),
            container.heightAnchor.constraint(equalToConstant: 50),
            
            symbolImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            symbolImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 30),
            symbolImageView.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(imageName: String?, name: String) {
        if let imgName = imageName {
            symbolImageView.image = UIImage(named: imgName)
        } else {
            symbolImageView.image = nil
        }
        nameLabel.text = name
    }
}
