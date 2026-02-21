//
//  FavoritesManager.swift
//  WeatherApp
//
//  Created by Adrian Gutierrez on 21/02/26.
//

import Foundation
import SwiftUI
import Combine

class FavoritesManager: ObservableObject {
    @Published var favoriteLocations: [String] = []
    
    private let favoritesKey = "savedFavorites"
    
    init() {
        loadFavorites()
    }
    
    func loadFavorites() {
        if let saved = UserDefaults.standard.array(forKey: favoritesKey) as? [String] {
            favoriteLocations = saved
        }
    }
    
    func toggleFavorite(locationName: String) {
        if favoriteLocations.contains(locationName) {
            favoriteLocations.removeAll { $0 == locationName }
        } else {
            favoriteLocations.append(locationName)
        }
        saveFavorites()
    }
    
    func isFavorite(locationName: String) -> Bool {
        return favoriteLocations.contains(locationName)
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(favoriteLocations, forKey: favoritesKey)
    }
}
