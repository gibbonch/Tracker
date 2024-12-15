//
//  TrackersDataSourceManagerDelegate.swift
//  Tracker
//
//  Created by Александр Торопов on 09.12.2024.
//

import Foundation

protocol TrackersDataSourceManagerDelegate: AnyObject {
    func didApplySnapshot(itemCount: Int)
}
