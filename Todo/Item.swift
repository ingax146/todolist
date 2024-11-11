//
//  Item.swift
//  Todo
//
//  Created by Ingemar Axelsson on 2024-11-11.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
