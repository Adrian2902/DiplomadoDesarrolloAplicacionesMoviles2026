//
//  HomeViewModel.swift
//  DonBigotes
//
//  Created by Adrian Gutierrez on 23/01/26.
//

import Foundation

class HomeViewModel {
    private var store: Store?

    var onDataLoaded: (() -> Void)?
    var onError: (() -> Void)?
    
    func loadStoreInfo() {
        if let loadedStore = Store.loadFromBundle() {
            self.store = loadedStore
            self.onDataLoaded?()
        } else {
            self.onError?()
        }
    }

    var title: String { store?.name ?? "Don Bigotes" }
    var slogan: String { store?.slogan ?? "" }
    var description: String { store?.description ?? "" }
    var logoUrl: String? { store?.logoUrl }
    var branches: [Branch] { store?.branches ?? [] }
}
