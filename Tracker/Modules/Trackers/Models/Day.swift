//
//  Day.swift
//  Tracker
//
//  Created by Александр Торопов on 14.11.2024.
//

import Foundation

enum Day: Int, CaseIterable, Codable {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    static func getDay(from date: Date) -> Day? {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        return Day(rawValue: weekday == 1 ? 7 : weekday - 1)
    }
    
    func toString() -> String {
        switch self {
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }
    
    func toShortString() -> String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
}
