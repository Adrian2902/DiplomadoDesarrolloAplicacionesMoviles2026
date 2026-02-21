//
//  PokemonType.swift
//  pokedex
//
//  Created by Adrian Gutierrez on 28/11/25.
//

import Foundation
import UIKit


struct PokemonType {
    let name: String
    let symbol: String
    let doubleDamageDealt: [String]
    let doubleDamageReceived: [String]
    let halfDamageDealt: [String]
    let halfDamageReceived: [String]
    let noEffectAgainst: [String]
    let notAffectedBy: [String]
}


struct Pokemon {
    let id: Int
    let name: String
    let description: String
    let typeNames: [String]
    let imageName: String
    let evolutionChainIds: [Int]
}
