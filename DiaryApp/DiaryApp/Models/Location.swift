//
//  Location.swift
//  DiaryApp
//
//  Created by Adrian Gutierrez on 30/01/26.
//

import Foundation
import CoreLocation

struct Location: Codable, Equatable {
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
