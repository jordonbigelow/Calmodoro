import Foundation
import SwiftData

@Model
class Task {
    var dateTimeCreated = Date()
    var title: String
    var notes: String
    
    init(dateTimeCreated: Date = .now, title: String = "", notes: String = "") {
        self.dateTimeCreated = dateTimeCreated
        self.title = title
        self.notes = notes
    }
}
