//
//  Parameter.swift
//  Tracker
//
//  Created by Александр Торопов on 17.11.2024.
//

import Foundation

struct Parameter {
    let title: String
    let details: String?
    
    init(title: String, details: String? = nil) {
        self.title = title
        self.details = details
    }
}
