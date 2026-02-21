//
//  MainTableView.swift
//  WeatherApp
//
//  Created by Adrian Gutierrez on 21/02/26.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var favoritesManager = FavoritesManager()
    
    var body: some View {
        TabView {
            LocationListView()
                .tabItem {
                    Label("Ubicación", systemImage: "mappin.and.ellipse")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favoritos", systemImage: "star")
                }
        }
        .environmentObject(favoritesManager)
    }
}
