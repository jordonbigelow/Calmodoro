import Foundation
import SwiftData

@Model
class Task {
    var dateTimeCreated = Date()
    var title: String
    var notes: String
    var pomodoroTimerGoal: Double
    var breakTimerGoal: Double
    
    init(dateTimeCreated: Date = .now, title: String = "", notes: String = "", pomodoroTimerGoal: Double = 1500, breakTimerGoal: Double = 300) {
        self.dateTimeCreated = dateTimeCreated
        self.title = title
        self.notes = notes
        self.pomodoroTimerGoal = pomodoroTimerGoal
        self.breakTimerGoal = breakTimerGoal
    }
}
