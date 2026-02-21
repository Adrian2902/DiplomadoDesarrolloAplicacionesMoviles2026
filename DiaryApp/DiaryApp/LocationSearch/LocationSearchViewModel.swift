//
//  LocationSearchViewModel.swift
//  DiaryApp
//
//  Created by Adrian Gutierrez on 30/01/26.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, MKLocalSearchCompleterDelegate {
    
    private var searchCompleter = MKLocalSearchCompleter()
    var searchResults: [MKLocalSearchCompletion] = []
    var onResultsUpdated: (() -> Void)?
    
    override init() {
        super.init()
        searchCompleter.delegate = self
    }
    
    func search(query: String) {
        searchCompleter.queryFragment = query
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        onResultsUpdated?()
    }
    
    func getCoordinate(for completion: MKLocalSearchCompletion, completionHandler: @escaping (Location?) -> Void) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let item = response?.mapItems.first else {
                completionHandler(nil)
                return
            }
            let coord = item.placemark.coordinate
            let loc = Location(name: completion.title, latitude: coord.latitude, longitude: coord.longitude)
            completionHandler(loc)
        }
    }
}
