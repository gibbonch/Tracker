//
//  Tracker.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import Foundation

struct Tracker: Hashable, Codable {
    var id = UUID()
    let type: TrackerType
    let title: String
    let colorID: Int
    let emoji: String
    let schedule: [Day]
    var checkCount: Int
    var isPin: Bool
    
    init(id: UUID = UUID(), type: TrackerType, title: String, colorID: Int, emoji: String, schedule: [Day], trackerValue: Int = 0, isPin: Bool = false) {
        self.id = id
        self.type = type
        self.title = title
        self.colorID = colorID
        self.emoji = emoji
        self.schedule = schedule
        self.checkCount = trackerValue
        self.isPin = isPin
    }
}
