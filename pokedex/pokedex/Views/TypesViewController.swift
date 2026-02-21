//
//  TypeListView.swift
//  pokedex
//
//  Created by Adrian Gutierrez on 28/11/25.
//

import UIKit

class TypesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    let types = DataManager.shared.allTypes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Types"
        view.backgroundColor = .systemBackground
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TypeCell.self, forCellWithReuseIdentifier: "TypeCell")
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCell", for: indexPath) as! TypeCell
        let type = types[indexPath.item]
        cell.configure(name: type.name, imageName: type.symbol)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedType = types[indexPath.item]
        let detailVC = TypeDetailViewController(type: selectedType)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

class TypeCell: UICollectionViewCell {
    let label = UILabel()
    let symbolImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        
        symbolImageView.contentMode = .scaleAspectFit
        
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14)
        
        let stack = UIStackView(arrangedSubviews: [symbolImageView, label])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10),
            
            symbolImageView.heightAnchor.constraint(equalToConstant: 50),
            symbolImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(name: String, imageName: String) {
        label.text = name
        symbolImageView.image = UIImage(named: imageName)
    }
}
