//
//  EditTasksView.swift
//  Calmodoro Timer
//
//  Created by Jordon Bigelow on 6/19/24.
//

import SwiftUI
import SwiftData

struct EditTasksView: View {
    @Bindable var task: Task
    
    var body: some View {
        Form {
            Text("Date Task Created: \($task.dateTimeCreated)")
            TextField("Title", text: $task.title)
            TextField("Notes", text: $task.notes)
        }
        .navigationTitle("Edit Task")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Task.self, configurations: config)
        let example = Task(dateTimeCreated: .now, title: "Example Title", notes: "Example Notes")
        
        return EditTasksView(task: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
