//
//  ContentView.swift
//  SwiftDataExample
//
//  Created by Jordon Bigelow on 6/2/24.
//


import SwiftUI
import SwiftData

struct ContentView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [Task]
    
    var body: some View {
        // MARK: - Timer View
        VStack {
            TimerView()
            // MARK: - Tasks View
            VStack {
                NavigationSplitView {
                    List {
                        ForEach(tasks) { item in
                            NavigationLink {
                                Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                            } label: {
                                Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Text("Tasks")
                        }
                        
                        ToolbarItem {
                            Button(action: addItem) {
                                Label("Add Item", systemImage: "plus")
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                    }
                } detail: {
                    Text("Select an item")
                }
            }
        }
        .background(.indigo)
    }
    
    
    // MARK: - Private Methods
    private func addItem() {
        withAnimation {
            let newTask = Task(timestamp: Date())
            modelContext.insert(newTask)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(tasks[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Task.self, inMemory: true)
}
