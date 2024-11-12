//
//  TodoItem.swift
//  Todo
//
//  Created by Ingemar Axelsson on 2024-11-11.
//

import Foundation
import SwiftData

@Model
final class TodoItem {
    var id = UUID()
    var title: String
    var content: String = "" //NOTE: AttributedString requires additional complexity for storing in swiftData
    var completed: Bool = false
    var creationDate: Date
    
    init(title: String, description: String) {
        self.creationDate = Date();
        self.completed = false
        self.content = description
        self.title = title
    }
}
