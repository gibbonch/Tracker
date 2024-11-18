//
//  Date+isEqual.swift
//  Tracker
//
//  Created by Александр Торопов on 17.11.2024.
//

import Foundation

extension Date {
    func isEqual(to date: Date) -> Bool {
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        return currentDateComponents.year == dateComponents.year &&
        currentDateComponents.month == dateComponents.month &&
        currentDateComponents.day == dateComponents.day
    }
}
