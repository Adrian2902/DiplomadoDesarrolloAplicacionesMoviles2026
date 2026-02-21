//
//  OpeningHours.swift
//  DonBigotes
//
//  Created by Adrian Gutierrez on 23/01/26.
//

import Foundation

struct OpeningHours: Codable {
    let weekdays: DailySchedule
    let saturday: DailySchedule
    let sunday: DailySchedule?
}

struct DailySchedule: Codable {
    let open: String
    let close: String
}
