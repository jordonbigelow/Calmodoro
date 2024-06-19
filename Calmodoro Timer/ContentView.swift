//
//  ContentView.swift
//  SwiftDataExample
//
//  Created by Jordon Bigelow on 6/2/24.
//


import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = [Task]()
    @State private var sortOrder = SortDescriptor(\Task.title)
    @State private var searchText = ""

    // MARK: - Main Body
    var body: some View {
        VStack {
            TimerView()
            NavigationStack(path: $path) {
                TasksView(sort: sortOrder, searchString: searchText)
                    .searchable(text: $searchText)
                    .navigationTitle("Tasks")
                    .navigationDestination(for: Task.self, destination: EditTasksView.init)
                    .toolbar {
                        Button("Add Task", systemImage: "plus", action: addTask)
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort", selection: $sortOrder) {
                                Text("Title").tag(SortDescriptor(\Task.title))
                                Text("Date Created").tag(SortDescriptor(\Task.dateTimeCreated))
                            }
                        }
                    }
            }
            
        }
        .background(.indigo)
    }
    
    // MARK: - Private Methods
    private func addTask() {
        withAnimation {
            let newTask = Task()
            modelContext.insert(newTask)
            path = [newTask]
        }
    }
}

#Preview {
    ContentView()
}
