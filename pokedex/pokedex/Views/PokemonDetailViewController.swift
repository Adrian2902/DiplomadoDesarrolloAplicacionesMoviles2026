//
//  PokemonDetailView.swift
//  pokedex
//
//  Created by Adrian Gutierrez on 28/11/25.
//

import UIKit

class PokemonDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let pokemon: Pokemon
    var tableView: UITableView!
    
    enum DetailSection: Int, CaseIterable {
        case number = 0
        case information
        case types
        case evolution
    }
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = pokemon.name
        
        setupTableView()
        setupHeaderView()
        setupFavoriteButton()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setupHeaderView() {
        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250))
        headerContainer.backgroundColor = .systemBackground
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: pokemon.imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        headerContainer.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        tableView.tableHeaderView = headerContainer
    }
    
    func setupFavoriteButton() {
        let isFav = DataManager.shared.isFavorite(id: pokemon.id)
        let imageName = isFav ? "star.fill" : "star"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeModal))
    }
    
    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func toggleFavorite() {
        DataManager.shared.toggleFavorite(id: pokemon.id)
        setupFavoriteButton()
    }
    
    // MARK: - TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetailSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = DetailSection(rawValue: section)
        
        switch sectionType {
        case .number: return 1
        case .information: return 1
        case .types: return pokemon.typeNames.count
        case .evolution: return pokemon.evolutionChainIds.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionType = DetailSection(rawValue: section)
        switch sectionType {
        case .number: return "Number"
        case .information: return "Information"
        case .types: return "Type"
        case .evolution: return "Evolution"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sectionType = DetailSection(rawValue: indexPath.section)
        var content = cell.defaultContentConfiguration()
        
        switch sectionType {
        case .number:
            content.text = String(format: "#%03d", pokemon.id)
            cell.accessoryType = .none
            cell.selectionStyle = .none
            
        case .information:
            content.text = pokemon.description
            content.textProperties.numberOfLines = 0
            cell.accessoryType = .none
            cell.selectionStyle = .none
            
        case .types:
            let typeName = pokemon.typeNames[indexPath.row]
            content.text = typeName
            
            if let typeObj = DataManager.shared.allTypes.first(where: { $0.name == typeName }) {
                content.image = UIImage(named: typeObj.symbol)
                content.imageProperties.maximumSize = CGSize(width: 30, height: 30) // Tamaño del icono
            }
            
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
        case .evolution:
            let evoId = pokemon.evolutionChainIds[indexPath.row]
            if let evoPokemon = DataManager.shared.getPokemon(byId: evoId) {
                content.text = evoPokemon.name
                content.image = UIImage(named: evoPokemon.imageName)
                content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
            }
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
        case .none:
            break
        }
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionType = DetailSection(rawValue: indexPath.section)
        
        switch sectionType {
        case .types:
            let typeName = pokemon.typeNames[indexPath.row]
            if let typeObj = DataManager.shared.allTypes.first(where: { $0.name == typeName }) {
                let typeVC = TypeDetailViewController(type: typeObj)
                navigationController?.pushViewController(typeVC, animated: true)
            }
            
        case .evolution:
            let evoId = pokemon.evolutionChainIds[indexPath.row]
            if evoId == pokemon.id {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            if let nextPokemon = DataManager.shared.getPokemon(byId: evoId) {
                let nextVC = PokemonDetailViewController(pokemon: nextPokemon)
                navigationController?.pushViewController(nextVC, animated: true)
            }
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
