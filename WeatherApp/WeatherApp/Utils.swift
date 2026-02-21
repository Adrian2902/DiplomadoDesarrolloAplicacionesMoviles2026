//
//  Utils.swift
//  WeatherApp
//
//  Created by Adrian Gutierrez on 21/02/26.
//

import Foundation
import SwiftUI

// MARK: - Carga de JSON Local
class DataLoader {
    static func loadLocations() -> [LocationItem] {
        guard let url = Bundle.main.url(forResource: "LocationList", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let locations = try? JSONDecoder().decode([LocationItem].self, from: data) else {
            return []
        }
        return locations
    }
}

// MARK: - Formateador de Fechas
class DateFormatterHelper {
    static func formatAPIString(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let date = inputFormatter.date(from: dateString) else { return dateString }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return outputFormatter.string(from: date)
    }
}

struct SafeImageView: View {
    let imageName: String
    
    var body: some View {
        if let uiImage = UIImage(named: imageName) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            ZStack {
                Color.gray.opacity(0.3)
                Image(systemName: "photo.badge.exclamationmark")
                    .foregroundColor(.gray)
            }
            .onAppear {
                print("ERROR : No se encontró la imagen '\(imageName)' en Assets.")
            }
        }
    }
}

// MARK: - Mapeo de Nombres de Imágenes
extension String {
    var imageNameForAsset: String {
        switch self {
        case "Canada":
            return "CanadáCA"
        default:
            return self
        }
    }
}
