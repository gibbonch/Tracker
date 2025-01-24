//
//  Utilities.swift
//  Tracker
//
//  Created by Александр Торопов on 10.12.2024.
//

import UIKit

final class Utilities {
    static func dayWord(for count: Int) -> String {
        switch count % 10 {
        case 1 where count % 100 != 11: return "день"
        case 2...4 where !(11...14).contains(count % 100): return "дня"
        default: return "дней"
        }
    }
    
    static func bringScheduleIntoLocaleFormat(_ schedule: inout [Weekday]) {
        let calendar = Calendar.current
        let firstWeekday = calendar.firstWeekday - 1

        let fullWeek = (0..<7).map { ($0 + firstWeekday) % 7 }

        schedule.sort { day1, day2 in
            let index1 = fullWeek.firstIndex(of: day1.rawValue) ?? 0
            let index2 = fullWeek.firstIndex(of: day2.rawValue) ?? 0
            return index1 < index2
        }
    }
    
    static func isCurrentLanguageRTL() -> Bool {
        return Locale.characterDirection(forLanguage: Locale.current.languageCode ?? "") == .rightToLeft
    }
}
