//
//  FavoritesView.swift
//  pokedex
//
//  Created by Adrian Gutierrez on 28/11/25.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var favoritePokemon: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        favoritePokemon = DataManager.shared.getFavoritePokemon()
        tableView.reloadData()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favCell")
    }
    
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)
        let poke = favoritePokemon[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = poke.name
        content.secondaryText = "#\(poke.id)"
        content.image = UIImage(named: poke.imageName)
        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemon = favoritePokemon[indexPath.row]
        let detailVC = PokemonDetailViewController(pokemon: selectedPokemon)
        
        let nav = UINavigationController(rootViewController: detailVC)
        present(nav, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pokemonToDelete = favoritePokemon[indexPath.row]
            
            DataManager.shared.removeFavorite(id: pokemonToDelete.id)

            favoritePokemon.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
