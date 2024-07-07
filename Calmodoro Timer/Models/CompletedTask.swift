//
//  CompletedTask.swift
//  Calmodoro Timer
//
//  Created by Jordon Bigelow on 6/30/24.
//

import SwiftData
import Foundation

@Model
class CompletedTask {
    var dateTimeCompleted: Date
    var dateTimeTaskCreated: Date
    var title: String
    var notes: String
    
    init(dateTimeCompleted: Date = .now, dateTimeTaskCreated: Date, title: String, notes: String) {
        self.dateTimeCompleted = dateTimeCompleted
        self.dateTimeTaskCreated = dateTimeTaskCreated
        self.title = title
        self.notes = notes
    }
}
