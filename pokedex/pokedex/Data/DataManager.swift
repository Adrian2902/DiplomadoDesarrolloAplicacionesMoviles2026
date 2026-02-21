//
//  PokemonData.swift
//  pokedex
//
//  Created by Adrian Gutierrez on 28/11/25.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    let allPokemon: [Pokemon]
    let allTypes: [PokemonType]
    
    private let favoritesKey = "FavoritesKey"
    
    private init() {

        let grass = PokemonType(name: "Grass", symbol: "grass", doubleDamageDealt: ["Water", "Ground", "Rock"], doubleDamageReceived: ["Fire", "Ice", "Poison", "Flying", "Bug"], halfDamageDealt: ["Fire", "Grass", "Poison", "Flying", "Bug", "Dragon", "Steel"], halfDamageReceived: ["Water", "Electric", "Grass", "Ground"], noEffectAgainst: [], notAffectedBy: [])
        
        let fire = PokemonType(name: "Fire", symbol: "fire", doubleDamageDealt: ["Grass", "Ice", "Bug", "Steel"], doubleDamageReceived: ["Water", "Ground", "Rock"], halfDamageDealt: ["Fire", "Water", "Rock", "Dragon"], halfDamageReceived: ["Fire", "Grass", "Ice", "Bug", "Steel", "Fairy"], noEffectAgainst: [], notAffectedBy: [])
        
        let water = PokemonType(name: "Water", symbol: "water", doubleDamageDealt: ["Fire", "Ground", "Rock"], doubleDamageReceived: ["Electric", "Grass"], halfDamageDealt: ["Water", "Grass", "Dragon"], halfDamageReceived: ["Fire", "Water", "Ice", "Steel"], noEffectAgainst: [], notAffectedBy: [])
        
        let electric = PokemonType(name: "Electric", symbol: "electric", doubleDamageDealt: ["Water", "Flying"], doubleDamageReceived: ["Ground"], halfDamageDealt: ["Electric", "Grass", "Dragon"], halfDamageReceived: ["Electric", "Flying", "Steel"], noEffectAgainst: ["Ground"], notAffectedBy: [])
        
        let normal = PokemonType(name: "Normal", symbol: "normal", doubleDamageDealt: [], doubleDamageReceived: ["Fighting"], halfDamageDealt: ["Rock", "Steel"], halfDamageReceived: [], noEffectAgainst: ["Ghost"], notAffectedBy: ["Ghost"])
        
        let psychic = PokemonType(name: "Psychic", symbol: "psychic", doubleDamageDealt: ["Fighting", "Poison"], doubleDamageReceived: ["Bug", "Ghost", "Dark"], halfDamageDealt: ["Psychic", "Steel"], halfDamageReceived: ["Fighting", "Psychic"], noEffectAgainst: ["Dark"], notAffectedBy: [])
        

        let ice = PokemonType(name: "Ice", symbol: "ice", doubleDamageDealt: [], doubleDamageReceived: [], halfDamageDealt: [], halfDamageReceived: [], noEffectAgainst: [], notAffectedBy: [])
        let ground = PokemonType(name: "Ground", symbol: "ground", doubleDamageDealt: [], doubleDamageReceived: [], halfDamageDealt: [], halfDamageReceived: [], noEffectAgainst: [], notAffectedBy: [])
        let flying = PokemonType(name: "Flying", symbol: "flying", doubleDamageDealt: [], doubleDamageReceived: [], halfDamageDealt: [], halfDamageReceived: [], noEffectAgainst: [], notAffectedBy: [])
        let bug = PokemonType(name: "Bug", symbol: "bug", doubleDamageDealt: [], doubleDamageReceived: [], halfDamageDealt: [], halfDamageReceived: [], noEffectAgainst: [], notAffectedBy: [])
        let rock = PokemonType(name: "Rock", symbol: "rock", doubleDamageDealt: [], doubleDamageReceived: [], halfDamageDealt: [], halfDamageReceived: [], noEffectAgainst: [], notAffectedBy: [])
        let ghost = PokemonType(name: "Ghost", symbol: "ghost", doubleDamageDealt: [], doubleDamageReceived: [], halfDamageDealt: [], halfDamageReceived: [], noEffectAgainst: [], notAffectedBy: [])
        let dragon = PokemonType(name: "Dragon", symbol: "dragon", doubleDamageDealt: [], doubleDamageReceived: [], halfDamageDealt: [], halfDamageReceived: [], noEffectAgainst: [], notAffectedBy: [])
        let steel = PokemonType(name: "Steel", symbol: "steel", doubleDamageDealt: [], doubleDamageReceived: [], halfDamageDealt: [], halfDamageReceived: [], noEffectAgainst: [], notAffectedBy: [])
        let dark = PokemonType(name: "Dark", symbol: "dark", doubleDamageDealt: [], doubleDamageReceived: [], halfDamageDealt: [], halfDamageReceived: [], noEffectAgainst: [], notAffectedBy: [])
        let fighting = PokemonType(name: "Fighting", symbol: "fighting", doubleDamageDealt: [], doubleDamageReceived: [], halfDamageDealt: [], halfDamageReceived: [], noEffectAgainst: [], notAffectedBy: [])
        let poison = PokemonType(name: "Poison", symbol: "poison", doubleDamageDealt: [], doubleDamageReceived: [], halfDamageDealt: [], halfDamageReceived: [], noEffectAgainst: [], notAffectedBy: [])


        self.allTypes = [grass, fire, water, electric, normal, psychic, ice, ground, flying, bug, rock, ghost, dragon, steel, dark, fighting, poison]
        
        

        self.allPokemon = [
            Pokemon(id: 1, name: "Bulbasaur", description: "A strange seed was planted on its back at birth.", typeNames: ["Grass"], imageName: "bulbasaur", evolutionChainIds: [1, 2, 3]),
            Pokemon(id: 2, name: "Ivysaur", description: "Exposure to sunlight adds to its strength.", typeNames: ["Grass"], imageName: "ivysaur", evolutionChainIds: [1, 2, 3]),
            Pokemon(id: 3, name: "Venusaur", description: "The plant blooms when it is absorbing solar energy.", typeNames: ["Grass"], imageName: "venusaur", evolutionChainIds: [1, 2, 3]),
            
            Pokemon(id: 4, name: "Charmander", description: "Obviously prefers hot places.", typeNames: ["Fire"], imageName: "charmander", evolutionChainIds: [4, 5, 6]),
            Pokemon(id: 5, name: "Charmeleon", description: "When it swings its burning tail, it elevates the temperature.", typeNames: ["Fire"], imageName: "charmeleon", evolutionChainIds: [4, 5, 6]),
            Pokemon(id: 6, name: "Charizard", description: "Spits fire that is hot enough to melt boulders.", typeNames: ["Fire"], imageName: "charizard", evolutionChainIds: [4, 5, 6]),
            
            Pokemon(id: 7, name: "Squirtle", description: "After birth, its back swells and hardens into a shell.", typeNames: ["Water"], imageName: "squirtle", evolutionChainIds: [7, 8, 9]),
            Pokemon(id: 8, name: "Wartortle", description: "It cleverly controls its furry ears and tail to maintain balance.", typeNames: ["Water"], imageName: "wartortle", evolutionChainIds: [7, 8, 9]),
            Pokemon(id: 9, name: "Blastoise", description: "The rocket cannons on its shell fire jets of water.", typeNames: ["Water"], imageName: "blastoise", evolutionChainIds: [7, 8, 9]),
            
            Pokemon(id: 172, name: "Pichu", description: "It is not yet skilled at storing electricity.", typeNames: ["Electric"], imageName: "pichu", evolutionChainIds: [172, 25, 26]),
            Pokemon(id: 25, name: "Pikachu", description: "When several of these Pokémon gather, their electricity builds.", typeNames: ["Electric"], imageName: "pikachu", evolutionChainIds: [172, 25, 26]),
            Pokemon(id: 26, name: "Raichu", description: "Its long tail serves as a ground to protect itself.", typeNames: ["Electric"], imageName: "raichu", evolutionChainIds: [172, 25, 26]),
            
            Pokemon(id: 133, name: "Eevee", description: "Its genetic code is irregular.", typeNames: ["Normal"], imageName: "eevee", evolutionChainIds: [133, 134, 135, 136]),
            Pokemon(id: 134, name: "Vaporeon", description: "Lives close to water.", typeNames: ["Water"], imageName: "vaporeon", evolutionChainIds: [133, 134, 135, 136]),
            Pokemon(id: 135, name: "Jolteon", description: "It controls 10,000-volt power.", typeNames: ["Electric"], imageName: "jolteon", evolutionChainIds: [133, 134, 135, 136]),
            Pokemon(id: 136, name: "Flareon", description: "It has a flame bag inside its body.", typeNames: ["Fire"], imageName: "flareon", evolutionChainIds: [133, 134, 135, 136]),
            
            Pokemon(id: 150, name: "Mewtwo", description: "It was created by a scientist after years of horrific gene splicing.", typeNames: ["Psychic"], imageName: "mewtwo", evolutionChainIds: [150])
        ].sorted(by: { $0.id < $1.id })
    }
    

    func getFavoritesIds() -> [Int] {
        return UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }
    
    func toggleFavorite(id: Int) {
        var favorites = getFavoritesIds()
        if favorites.contains(id) {
            favorites.removeAll { $0 == id }
        } else {
            favorites.append(id)
        }
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    
    func removeFavorite(id: Int) {
        var favorites = getFavoritesIds()
        favorites.removeAll { $0 == id }
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    
    func isFavorite(id: Int) -> Bool {
        return getFavoritesIds().contains(id)
    }
    
    func getFavoritePokemon() -> [Pokemon] {
        let ids = getFavoritesIds()
        return allPokemon.filter { ids.contains($0.id) }
    }
    
    func getPokemon(byId id: Int) -> Pokemon? {
        return allPokemon.first(where: { $0.id == id })
    }
    

    func getSymbol(forTypeName name: String) -> String {
        return allTypes.first(where: { $0.name == name })?.symbol ?? "circle"
    }
}
