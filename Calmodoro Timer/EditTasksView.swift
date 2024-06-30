//
//  EditTasksView.swift
//  Calmodoro Timer
//
//  Created by Jordon Bigelow on 6/19/24.
//

import SwiftUI
import SwiftData
import Foundation

struct EditTasksView: View {
    @Bindable var task: Task
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
        
    var body: some View {
        Form {
            Text("Created: \(dateFormatter.string(from: task.dateTimeCreated))")
            TextField("Title", text: $task.title)
            HStack {
                Text("Notes: ")
                TextEditor(text: $task.notes)
            }
        }
        .navigationTitle("Edit Task")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .navigationBarItems(trailing: Button("Save") {
                    if task.title.trimmingCharacters(in: .whitespaces).isEmpty {
                        showingAlert = true
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Missing Title"),
                        message: Text("Title is required"),
                        dismissButton: .default(Text("OK"))
                    )
                }
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
