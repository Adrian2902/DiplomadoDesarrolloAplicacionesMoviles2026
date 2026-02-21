//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Adrian Gutierrez on 21/02/26.
//

import Foundation

class WeatherService {
    static let shared = WeatherService()
    
    private init() {}
    
    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "WeatherAPIKey") as? String else {
            fatalError("No se encontró WeatherAPIKey")
        }
        return key
    }
    
    func fetchWeather(for location: String) async throws -> WeatherResponse {
        let query = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? location
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(query)&aqi=no"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
