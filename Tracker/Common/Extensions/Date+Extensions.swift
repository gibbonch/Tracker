//
//  Date+Extensions.swift
//  Tracker
//
//  Created by Александр Торопов on 17.11.2024.
//

import Foundation

extension Date {
    var weekday: Weekday? {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        return Weekday(rawValue: weekday == 0 ? 7 : weekday - 1)
    }
}
