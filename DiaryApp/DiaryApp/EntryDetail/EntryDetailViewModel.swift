//
//  EntryDetailViewModel.swift
//  DiaryApp
//
//  Created by Adrian Gutierrez on 30/01/26.
//

import Foundation
import UIKit

class EntryDetailViewModel {
    let entry: DiaryEntry
    var image: UIImage?
    
    init(entry: DiaryEntry) {
        self.entry = entry
        if let imgName = entry.imageFileName {
            self.image = DiaryDataService.shared.loadImage(named: imgName)
        }
    }
}
