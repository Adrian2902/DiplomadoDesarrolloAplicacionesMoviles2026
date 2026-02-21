//
//  DiaryDataService.swift
//  DiaryApp
//
//  Created by Adrian Gutierrez on 30/01/26.
//

import Foundation
import UIKit

class DiaryDataService {
    static let shared = DiaryDataService()
    private let fileName = "diary_entries.json"
    
    private init() {}
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - JSON Handling
    func loadEntries() -> [DiaryEntry] {
        let url = documentsDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else { return [] }
        do {
            let entries = try JSONDecoder().decode([DiaryEntry].self, from: data)
            return entries.sorted(by: { $0.date > $1.date })
        } catch {
            debugPrint("Error decoding: \(error)")
            return []
        }
    }
    
    func saveEntry(_ entry: DiaryEntry) {
        var entries = loadEntries()
        
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        } else {
            entries.insert(entry, at: 0)
        }
        
        persist(entries)
    }
    
    func deleteEntry(_ entry: DiaryEntry) {
        var entries = loadEntries()
        entries.removeAll { $0.id == entry.id }
        persist(entries)

        if let imgName = entry.imageFileName {
            let imgURL = documentsDirectory.appendingPathComponent(imgName)
            try? FileManager.default.removeItem(at: imgURL)
        }
    }
    
    private func persist(_ entries: [DiaryEntry]) {
        let url = documentsDirectory.appendingPathComponent(fileName)
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: url)
        } catch {
            debugPrint("Error saving: \(error)")
        }
    }
    
    // MARK: - Image Handling
    func saveImage(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let fileName = UUID().uuidString + ".jpg"
        let url = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: url)
            return fileName
        } catch {
            debugPrint("Error saving image: \(error)")
            return nil
        }
    }
    
    func loadImage(named fileName: String) -> UIImage? {
        let url = documentsDirectory.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: url.path)
    }
}
