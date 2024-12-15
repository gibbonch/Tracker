//
//  TrackerStorage.swift
//  Tracker
//
//  Created by Александр Торопов on 14.12.2024.
//

import Foundation

protocol TrackerStorage {
    func fetchTrackers(from categoryTitle: String) -> [Tracker]
    func fetchCategoryTitle(for tracker: Tracker) -> String?
    func create(tracker: Tracker, in categoryTitle: String)
    func delete(tracker: Tracker, from categoryTitle: String)
}
