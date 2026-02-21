//
//  PersistenceManager.swift
//  GitApp
//
//  Created by Adrian Gutierrez on 15/01/26.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum GFError: String, Error {
    case alreadyInFavorites = "Ya tienes este usuario en favoritos."
    case unableToFavorite = "Hubo un error al guardar."
}

class PersistenceManager {
    static private let defaults = UserDefaults.standard
    static private let keys = "favorites"
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (Error?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completed(GFError.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }
                completed(save(favorites: favorites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], Error>) -> Void) {
        guard let favoritesData = defaults.object(forKey: keys) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(error))
        }
    }
    
    static private func save(favorites: [Follower]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: keys)
            return nil
        } catch {
            return error
        }
    }
}
