//
//  ContentView.swift
//  SwiftDataExample
//
//  Created by Jordon Bigelow on 6/2/24.
//

/*
 TODO:
 I want the tasks to link with the timers. So esentially, if you make a
 timer by interacting with the set timer function, and then click the plus
 button, it will create a task that you can then touch that will set the
 timer to whatever time is stored in that task. Essentially, this makes
 it super easy to estimate how long a task will take you to complete, it
 will promote the pomodoro method by causing you to chunk a large task
 into a smaller task you can accomplish in a small amount of time, such as
 20-40 minutes with a 5-15 minute break afterwards.
 */

import SwiftUI
import SwiftData

struct ContentView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Task]
    
    var body: some View {
        // MARK: - Timer View
        VStack {
            TimerView()
            // MARK: - Tasks View
            VStack {
                NavigationSplitView {
                    List {
                        ForEach(items) { item in
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
            let newItem = Task(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Task.self, inMemory: true)
}
