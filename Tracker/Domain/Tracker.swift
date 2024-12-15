//
//  Tracker.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import UIKit

// MARK: - Tracker

struct Tracker: Hashable {
    let id: UUID
    let type: TrackerType
    let title: String
    let schedule: [Weekday]
    let color: UIColor
    let emoji: String
    
    init(id: UUID = UUID(), type: TrackerType, title: String, schedule: [Weekday], color: UIColor, emoji: String) {
        self.id = id
        self.type = type
        self.title = title
        self.schedule = schedule
        self.color = color
        self.emoji = emoji
    }
}

// MARK: - Weekday

enum Weekday: Int, CaseIterable, Codable {
    case  sunday, monday, tuesday, wednesday, thursday, friday, saturday
}

// MARK: - TrackerType

enum TrackerType: String, Codable {
    case regular
    case single
}
