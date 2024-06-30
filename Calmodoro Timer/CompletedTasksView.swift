//
//  CompletedTasksView.swift
//  Calmodoro Timer
//
//  Created by Jordon Bigelow on 6/30/24.
//

import SwiftUI
import SwiftData

struct CompletedTasksView: View {
    @Query var completedTasks: [CompletedTask]
    @Environment(\.modelContext) var modelContext
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    init(sort: SortDescriptor<CompletedTask>, searchString: String) {
        _completedTasks = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true
            } else {
                return $0.title
                    .localizedStandardContains(searchString)
            }
        }, sort: [sort])
    }

    var body: some View {
        List {
            ForEach(completedTasks) { task in
                NavigationLink(value: task) {
                    VStack {
                        Text("Date task created: \(dateFormatter.string(from: task.dateTimeTaskCreated))")
                        Text("Date task completed: \(dateFormatter.string(from: task.dateTimeCompleted))")
                        Text("\(task.title)")
                        Text("\(task.notes)")
                    }
                }
            }
            .onDelete(perform: deleteTasks)
        }
    }
    
    func deleteTasks(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(completedTasks[index])
        }
    }
}

#Preview {
    CompletedTasksView(sort: SortDescriptor(\CompletedTask.title), searchString: "")
}
