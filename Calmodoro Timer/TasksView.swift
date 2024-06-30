//
//  TasksView.swift
//  Calmodoro Timer
//
//  Created by Jordon Bigelow on 6/19/24.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Query private var tasks: [Task]
    @Environment(\.modelContext) var modelContext
    
    init(sort: SortDescriptor<Task>, searchString: String) {
        _tasks = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true
            } else {
                return $0.title.localizedStandardContains(searchString) ||
                $0.notes.localizedStandardContains(searchString)
            }
        }, sort: [sort])
    }
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                NavigationLink(value: task) {
                    VStack {
                        Text("\(task.title)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                        Text("\(task.notes)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.light)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            completeTask(task: task)
                        } label: {
                            Label("Complete", systemImage: "checkmark.circle")
                        }
                        .tint(.green)
                    }
                }
            }
            .onDelete(perform: deleteTasks)
        }
    }
    
    func deleteTasks(_ indexSet: IndexSet) {
        withAnimation {
            for index in indexSet {
                modelContext.delete(tasks[index])
            }
        }
    }
    
    func completeTask(task: Task) {
        withAnimation {
            let completedTask = CompletedTask(dateTimeTaskCreated: task.dateTimeCreated, title: task.title, notes: task.notes)
            modelContext.insert(completedTask)
            modelContext.delete(task)
        }
    }
}

#Preview {
    TasksView(sort: SortDescriptor(\Task.title), searchString: "")
}
