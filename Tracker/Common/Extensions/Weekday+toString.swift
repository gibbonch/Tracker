//
//  Weekday+toString.swift
//  Tracker
//
//  Created by Александр Торопов on 02.12.2024.
//

import Foundation

extension Weekday {
    func toString() -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "Ru-ru")
        let weekdays = calendar.weekdaySymbols.map{ $0.capitalizingFirstLetter() }
        return weekdays[self.rawValue]
    }
    
    func toShortString() -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "Ru-ru")
        let weekdays = calendar.shortWeekdaySymbols.map{ $0.capitalizingFirstLetter() }
        return weekdays[self.rawValue]
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
