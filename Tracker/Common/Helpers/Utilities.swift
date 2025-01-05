//
//  Utilities.swift
//  Tracker
//
//  Created by Александр Торопов on 10.12.2024.
//

import Foundation

final class Utilities {
    static func dayWord(for count: Int) -> String {
        switch count % 10 {
        case 1 where count % 100 != 11: return "день"
        case 2...4 where !(11...14).contains(count % 100): return "дня"
        default: return "дней"
        }
    }
    
    static func bringScheduleIntoRuFormat(_ schedule: inout [Weekday]) {
        schedule.sort { $0.rawValue < $1.rawValue }
        if let index = schedule.firstIndex(where: { $0 == .sunday }) {
            let sunday = schedule.remove(at: index)
            schedule.append(sunday)
        }
    }
}
