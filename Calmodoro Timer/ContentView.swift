//
//  ContentView.swift
//  SwiftDataExample
//
//  Created by Jordon Bigelow on 6/2/24.
//

/*
//MARK: - TODO
-Figure out how to change the behavior of Swift Data, currently we need to know how to alter the model
 so that we can create our own "Task" model, as well as the deatil view. I want tasks to be able to be
 marked as complete and go to another table or something separate. The task needs to have a timer
 to be associated with it so when a user touches one of the tasks, it loads the timer into memory.

 -I want the tasks to link with the timers. So esentially, if you make a
 timer by interacting with the set timer function, and then click the plus
 button, it will create a task that you can then touch that will set the
 timer to whatever time is stored in that task. Essentially, this makes
 it super easy to estimate how long a task will take you to complete, it
 will promote the pomodoro method by causing you to chunk a large task
 into a smaller task you can accomplish in a small amount of time, such as
 20-40 minutes with a 5-15 minute break afterwards.
 
 -Figure out a way to make it obvious that a timer is "set". Currently the user doesn't truly know if
  the timer got set, other than checking the set timer button, but I don't think that's intuitive
 
//MARK: - Active Task
 -Shadow color on the start/pause and reset buttons is a different color compared to the top buttons shadow color

 MARK: - BUGS
 -if the user is scrolling, the timer pauses ugh...the ui interaction is hanging the thread for the timer
 */

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
