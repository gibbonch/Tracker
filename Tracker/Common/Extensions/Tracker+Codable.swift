//
//  Tracker+Codable.swift
//  Tracker
//
//  Created by Александр Торопов on 08.12.2024.
//

import UIKit

extension Tracker: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, type, title, schedule, color, emoji
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let colorComponents = [red, green, blue, alpha]
        try container.encode(colorComponents, forKey: .color)

        try container.encode(emoji, forKey: .emoji)
        try container.encode(schedule, forKey: .schedule)
        try container.encode(type, forKey: .type)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)

        let colorComponents = try container.decode([CGFloat].self, forKey: .color)
        color = UIColor(
            red: colorComponents[0],
            green: colorComponents[1],
            blue: colorComponents[2],
            alpha: colorComponents[3]
        )

        emoji = try container.decode(String.self, forKey: .emoji)
        schedule = try container.decode([Weekday].self, forKey: .schedule)
        type = try container.decode(TrackerType.self, forKey: .type)
    }
}
