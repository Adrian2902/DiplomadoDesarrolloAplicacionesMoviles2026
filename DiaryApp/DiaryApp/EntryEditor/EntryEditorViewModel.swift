//
//  EntryEditorViewModel.swift
//  DiaryApp
//
//  Created by Adrian Gutierrez on 30/01/26.
//

import Foundation
import UIKit

class EntryEditorViewModel {
    
    var entry: DiaryEntry
    var selectedImage: UIImage?
    
    init(existingEntry: DiaryEntry?) {
        if let existing = existingEntry {
            self.entry = existing
            if let imgName = existing.imageFileName {
                self.selectedImage = DiaryDataService.shared.loadImage(named: imgName)
            }
        } else {
            
            self.entry = DiaryEntry(id: UUID(), title: "", message: "", date: Date(), imageFileName: nil, location: nil, isDraft: true)
        }
    }
    
    func updateLocation(_ location: Location) {
        entry.location = location
    }
    
    func save(title: String, message: String, isDraft: Bool, completion: () -> Void) {
        entry.title = title
        entry.message = message
        entry.isDraft = isDraft
        entry.date = Date()
        
        if let image = selectedImage {
            if let savedName = DiaryDataService.shared.saveImage(image) {
                entry.imageFileName = savedName
            }
        }
        
        DiaryDataService.shared.saveEntry(entry)
        completion()
    }
}
