//
//  TrackerRecordStorage.swift
//  Tracker
//
//  Created by Александр Торопов on 14.12.2024.
//

import Foundation

protocol TrackerRecordStorage {
    func fetchRecords(for tracker: Tracker) -> [TrackerRecord]
    func create(record: TrackerRecord)
    func delete(record: TrackerRecord)
}
