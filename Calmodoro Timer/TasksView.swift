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
                return $0.title
                    .localizedStandardContains(searchString)
            }
        }, sort: [sort])
    }
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                NavigationLink(value: task) {
                    HStack {
                        Text("\(task.title)")
                    }
                }
            }
            .onDelete(perform: deleteTasks)
        }
    }
    
    func deleteTasks(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(tasks[index])
        }
    }
}

#Preview {
    TasksView(sort: SortDescriptor(\Task.title), searchString: "")
}
