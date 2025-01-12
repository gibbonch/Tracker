//
//  Weekday+Extensions.swift
//  Tracker
//
//  Created by Александр Торопов on 02.12.2024.
//

import Foundation

extension Weekday {
    func toString() -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "Ru-ru")
        let weekdays = calendar.weekdaySymbols.map{ $0.capitalized }
        return weekdays[self.rawValue]
    }
    
    func toShortString() -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "Ru-ru")
        let weekdays = calendar.shortWeekdaySymbols.map{ $0.capitalized }
        return weekdays[self.rawValue]
    }
}
