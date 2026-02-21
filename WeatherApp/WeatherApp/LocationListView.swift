//
//  LocationListView.swift
//  WeatherApp
//
//  Created by Adrian Gutierrez on 21/02/26.
//

import SwiftUI

struct LocationListView: View {
    @State private var locations: [LocationItem] = []
    
    var body: some View {
        NavigationView {
            List(locations) { location in
                NavigationLink(destination: LocationDetailView(locationName: location.nombre)) {
                    HStack {
                        Text(location.nombre)
                            .font(.headline)
                        Spacer()
                        
                        SafeImageView(imageName: location.nombre.imageNameForAsset)
                            .scaledToFit()
                            .frame(width: 50, height: 30)
                            .cornerRadius(4)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Ubicaciones")
            .onAppear {
                locations = DataLoader.loadLocations()
            }
        }
    }
}
