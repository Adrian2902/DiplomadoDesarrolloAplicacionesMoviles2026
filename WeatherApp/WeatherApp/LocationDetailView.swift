//
//  LocationDetailView.swift
//  WeatherApp
//
//  Created by Adrian Gutierrez on 21/02/26.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    let locationName: String
    
    @StateObject private var viewModel = LocationDetailViewModel()
    @EnvironmentObject var favoritesManager: FavoritesManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var temperatureUnit = 0
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView("Cargando...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                    
                case .loaded(let weather):
                    weatherContentView(weather: weather)
                    
                case .error(let message):
                    Color.clear
                        .onAppear {
                            errorMessage = message
                            showErrorAlert = true
                        }
                }
            }
        }
        .navigationTitle(locationName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    favoritesManager.toggleFavorite(locationName: locationName)
                }) {
                    Image(systemName: favoritesManager.isFavorite(locationName: locationName) ? "star.fill" : "star")
                        .foregroundColor(favoritesManager.isFavorite(locationName: locationName) ? .yellow : .blue)
                }
            }
        }
        .task {
            await viewModel.fetchWeather(for: locationName)
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    // MARK: - Componentes de la Vista
    
    private var backgroundColor: Color {
        guard case .loaded(let weather) = viewModel.state else { return Color(UIColor.systemBackground) }

        return weather.current.is_day == 1 ? Color("ColorDia") : Color("ColorNoche")
    }
    
    private func weatherContentView(weather: WeatherResponse) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("\(weather.location.name), \(weather.location.country)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Picker("Temperatura", selection: $temperatureUnit) {
                    Text("C").tag(0)
                    Text("F").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 150)
                
                HStack(spacing: 30) {

                    AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    
                    let temp = temperatureUnit == 0 ? weather.current.temp_c : weather.current.temp_f
                    Text(String(format: "%.1f°", temp))
                        .font(.system(size: 60, weight: .bold))
                    
                    Text("UV: \(String(format: "%.1f", weather.current.uv))")
                        .font(.headline)
                }
                
                Text(DateFormatterHelper.formatAPIString(weather.location.localtime))
                    .font(.subheadline)

                Map(coordinateRegion: $viewModel.region)
                    .frame(height: 250)
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Text("Last update: \(DateFormatterHelper.formatAPIString(weather.current.last_updated))")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
            }
            .padding(.top, 20)
            .foregroundColor(weather.current.is_day == 1 ? .black : .white)
        }
    }
}
