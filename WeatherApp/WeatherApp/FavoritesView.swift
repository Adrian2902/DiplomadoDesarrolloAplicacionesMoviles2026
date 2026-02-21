//
//  FavoritesView.swift
//  WeatherApp
//
//  Created by Adrian Gutierrez on 21/02/26.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(favoritesManager.favoriteLocations, id: \.self) { locationName in
                        NavigationLink(destination: LocationDetailView(locationName: locationName)) {
                            SafeImageView(imageName: locationName.imageNameForAsset)
                                .scaledToFit()
                                .frame(height: 80)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Favoritos")
        }
        .onAppear {
            favoritesManager.loadFavorites()
        }
    }
}
