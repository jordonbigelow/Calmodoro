//
//  ContentView.swift
//  Calmodoro Timer App
//
//  Created by Jordon Bigelow on 6/2/24.
//


import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var taskPath = [Task]()
    @State private var completedPath = [CompletedTask]()
    @State private var taskSortOrder = SortDescriptor(\Task.title)
    @State private var completedSortOrder = SortDescriptor(\CompletedTask.title)
    @State private var searchText = ""
    @State private var isCompletedTasksDisplayed = false
    @State private var isTasksDisplayed = true

    // MARK: - Main Body
    var body: some View {
        VStack {
            ScrollView {
                TimerView()
            }
            NavigationStack(path: $taskPath) {
                if isTasksDisplayed {
                    TasksView(sort: taskSortOrder, searchString: searchText)
                        .searchable(text: $searchText)
                        .navigationTitle("Tasks")
                        .navigationDestination(for: Task.self) { task in
                            EditTasksView(task: task)
                        }
                        .toolbar {
                            Button(action: {
                                isTasksDisplayed = true
                                isCompletedTasksDisplayed = false
                            }, label: {
                                Text("Tasks")
                            })
                            Button(action: {
                                isTasksDisplayed = false
                                isCompletedTasksDisplayed = true
                            }, label: {
                                Text("Completed")
                            })
                            Button("Add Task", systemImage: "plus", action: addTask)
                            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                                Picker("Sort", selection: $taskSortOrder) {
                                    Text("Title").tag(SortDescriptor(\Task.title))
                                    Text("Date Created").tag(SortDescriptor(\Task.dateTimeCreated))
                                }
                            }
                        }
                } else {
                    CompletedTasksView(sort: completedSortOrder, searchString: searchText)
                        .searchable(text: $searchText)
                        .navigationTitle("CompletedTasks")
                        .toolbar {
                            Button(action: {
                                isTasksDisplayed = true
                                isCompletedTasksDisplayed = false
                            }, label: {
                                Text("Tasks")
                            })
                            Button(action: {
                                isTasksDisplayed = false
                                isCompletedTasksDisplayed = true
                            }, label: {
                                Text("Completed")
                            })
                            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                                Picker("Sort", selection: $completedSortOrder) {
                                    Text("Title").tag(SortDescriptor(\CompletedTask.title))
                                    Text("Date Completed").tag(SortDescriptor(\CompletedTask.dateTimeCompleted))
                                }
                            }
                        }
                }
            }
            .frame(height: 275)
        }
        .background(.indigo)
    }
    
    // MARK: - Private Methods
    private func addTask() {
        withAnimation {
            let newTask = Task()
            modelContext.insert(newTask)
            taskPath = [newTask]
        }
    }
}

#Preview {
    ContentView()
}
