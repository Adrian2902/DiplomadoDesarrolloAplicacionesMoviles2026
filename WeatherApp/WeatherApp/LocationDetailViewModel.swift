//
//  LocationDetailViewModel.swift
//  WeatherApp
//
//  Created by Adrian Gutierrez on 21/02/26.
//

import Foundation
import SwiftUI
import MapKit
import Combine

enum ViewState {
    case loading
    case loaded(WeatherResponse)
    case error(String)
}

@MainActor
class LocationDetailViewModel: ObservableObject {
    @Published var state: ViewState = .loading
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    
    func fetchWeather(for location: String) async {
        state = .loading
        do {
            let response = try await WeatherService.shared.fetchWeather(for: location)
            self.state = .loaded(response)
            
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: response.location.lat, longitude: response.location.lon),
                span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
            )
        } catch {
            self.state = .error("No se pudo obtener la información del clima. Por favor, intenta de nuevo.")
        }
    }
}
