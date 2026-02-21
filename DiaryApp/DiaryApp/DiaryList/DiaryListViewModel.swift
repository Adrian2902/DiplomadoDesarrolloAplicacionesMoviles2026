//
//  DiarylistVieModel.swift
//  DiaryApp
//
//  Created by Adrian Gutierrez on 30/01/26.
//

import Foundation

class DiaryListViewModel {
    var entries: [DiaryEntry] = []
    
    func loadEntries() {
        entries = DiaryDataService.shared.loadEntries()
    }
    
    func deleteEntry(at index: Int) {
        let entry = entries[index]
        DiaryDataService.shared.deleteEntry(entry)
        entries.remove(at: index)
    }
}
