//
//  Branch.swift
//  DonBigotes
//
//  Created by Adrian Gutierrez on 23/01/26.
//

import Foundation

struct Branch: Codable {
    let id: Int
    let name: String
    let address: String
    let phone: String
    let openingHours: OpeningHours
    let location: Location
    let services: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, address, phone
        case openingHours = "opening_hours"
        case location, services
    }
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}
