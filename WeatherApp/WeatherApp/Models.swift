//
//  Models.swift
//  WeatherApp
//
//  Created by Adrian Gutierrez on 21/02/26.
//

import Foundation

// MARK: - Modelo para el JSON Local
struct LocationItem: Codable, Identifiable {
    let id: Int
    let nombre: String
}

// MARK: - Modelos para WeatherAPI
struct WeatherResponse: Codable {
    let location: WeatherLocation
    let current: CurrentWeather
}

struct WeatherLocation: Codable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    let localtime: String
}

struct CurrentWeather: Codable {
    let last_updated: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: WeatherCondition
    let uv: Double
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
}
