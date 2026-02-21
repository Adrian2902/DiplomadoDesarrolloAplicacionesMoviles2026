//
//  PokemonListView.swift
//  pokedex
//
//  Created by Adrian Gutierrez on 28/11/25.
//

import UIKit

class PokemonListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPokemon: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokédex"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupSearch()
        filteredPokemon = DataManager.shared.allPokemon
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Name or Number"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Search Logic
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            filteredPokemon = DataManager.shared.allPokemon
            tableView.reloadData()
            return
        }
        
        filteredPokemon = DataManager.shared.allPokemon.filter {
            $0.name.lowercased().contains(text.lowercased()) || String($0.id).contains(text)
        }
        tableView.reloadData()
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let poke = filteredPokemon[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = poke.name
        content.secondaryText = "#\(poke.id)"
        content.image = UIImage(named: poke.imageName)
        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemon = filteredPokemon[indexPath.row]
        let detailVC = PokemonDetailViewController(pokemon: selectedPokemon)
        
        let nav = UINavigationController(rootViewController: detailVC)
        
        nav.modalPresentationStyle = .automatic
        
        present(nav, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
