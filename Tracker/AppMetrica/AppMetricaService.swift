//
//  AppMetricaService.swift
//  Tracker
//
//  Created by Александр Торопов on 28.01.2025.
//

import Foundation
import YandexMobileMetrica

enum Event: String {
    case open
    case close
    case click
}

enum Screen: String {
    case Main
}

enum Item: String {
    case addTrack = "add_track"
    case track
    case filter
    case edit
    case delete
}

struct AppMetricaService {
    func reportEvent(event: Event, screen: Screen, item: Item?) {
        var params: [AnyHashable: Any] = [
            String(describing: Event.self): event.rawValue,
            String(describing: Screen.self): screen.rawValue
        ]
        
        if let item {
            params[String(describing: Item.self)] = item.rawValue
        }
        
        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { error in
            Logger.error("REPORT ERROR: \(error.localizedDescription)")
        })
    }
}
