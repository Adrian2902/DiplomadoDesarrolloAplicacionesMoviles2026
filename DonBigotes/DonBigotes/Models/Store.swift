//
//  Store.swift
//  DonBigotes
//
//  Created by Adrian Gutierrez on 23/01/26.
//

import Foundation

struct StoreResponse: Codable {
    let store: Store
}

struct Store: Codable {
    let name: String
    let slogan: String
    let description: String
    let logoUrl: String
    let branches: [Branch]

    enum CodingKeys: String, CodingKey {
        case name, slogan, description
        case logoUrl = "logo_url"
        case branches
    }
    

    static func loadFromBundle() -> Store? {
        guard let url = Bundle.main.url(forResource: "don_bigotes", withExtension: "json") else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(StoreResponse.self, from: data)
            return response.store
        } catch {
            return nil
        }
    }
}
