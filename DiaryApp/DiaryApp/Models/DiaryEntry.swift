//
//  DiaryEntry.swift
//  DiaryApp
//
//  Created by Adrian Gutierrez on 30/01/26.
//

import Foundation

struct DiaryEntry: Codable, Equatable, Identifiable {
    let id: UUID
    var title: String
    var message: String
    var date: Date
    var imageFileName: String?
    var location: Location?
    var isDraft: Bool
}
