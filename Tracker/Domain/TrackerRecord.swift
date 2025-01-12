//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import Foundation

struct TrackerRecord {
    let trackerID: UUID
    let date: Date
    
    init(trackerID: UUID, date: Date) {
        self.trackerID = trackerID
        self.date = date
    }
}
