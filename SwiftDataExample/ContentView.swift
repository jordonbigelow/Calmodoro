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
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Task]
    
    @State var pomodoroTimer = Date()
    @State var breakTimer = Date()

    @State var isPomodoroDatePickerVisible = false
    @State var isPomodoroTimerActive = true
    
    @State var isBreakTimerActive = false
    @State var isBreakDatePickerVisible = false
    
    @State var isSetTimerButtonActive = false
    
    @State var isStartButtonPressed = false
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    if !isStartButtonPressed {
                        Button("Pomodoro", action: {
                            isPomodoroTimerActive = true
                            isBreakTimerActive = false
                        })
                        .padding(5)
                        .background(isPomodoroTimerActive ? .yellow: .teal)
                        .cornerRadius(5)
                        .shadow(radius: isPomodoroTimerActive ? 5 : 0)
                        
                        Button("Break", action: {
                            isBreakTimerActive = true
                            isPomodoroTimerActive = false
                        })
                        .padding(5)
                        .background(isBreakTimerActive ? .yellow: .teal)
                        .cornerRadius(5)
                        .shadow(radius: isBreakTimerActive ? 5 : 0)
                                        
                        Button ("Set Timer", action: {
                            isSetTimerButtonActive.toggle()
                        })
                        .padding(5)
                        .background(isSetTimerButtonActive ? .yellow: .teal)
                        .cornerRadius(5)
                        .shadow(radius: isSetTimerButtonActive ? 5 : 0)
                    }
                }
                .foregroundColor(.indigo)
            
                var formattedPomodoroTime: String {
                    let calendar = Calendar.current
                    let hours = calendar.component(.hour, from: pomodoroTimer)
                    let minutes = calendar.component(.minute, from: pomodoroTimer)
                    return String(format: "%02d:%02d", hours, minutes)
                }
                
                var formattedBreakTime: String {
                    let calendar = Calendar.current
                    let hours = calendar.component(.hour, from: breakTimer)
                    let minutes = calendar.component(.minute, from: breakTimer)
                    return String(format: "%02d:%02d", hours, minutes)
                }
                
                if isPomodoroTimerActive && isSetTimerButtonActive && !isStartButtonPressed {
                    DatePicker("Selected Time", selection: $pomodoroTimer, displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "en_GB"))
                } else if isBreakTimerActive && isSetTimerButtonActive && !isStartButtonPressed {
                    DatePicker("Selected Time", selection: $breakTimer, displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "en_GB"))
                }
                
                if isPomodoroTimerActive {
                 Text("\(formattedPomodoroTime)")
                        .font(.largeTitle)
                        .bold()
                        .padding(15)
                        .foregroundColor(isStartButtonPressed && !isSetTimerButtonActive ? .yellow: .green)
                }
                
                if isBreakTimerActive {
                  Text("\(formattedBreakTime)")
                    .font(.largeTitle)
                    .bold()
                    .padding(15)
                    .foregroundColor(isStartButtonPressed && !isSetTimerButtonActive ? .yellow : .green)
                }
                if !isSetTimerButtonActive {
                    Button(isStartButtonPressed && !isSetTimerButtonActive ? "PAUSE" : "START", action: {
                        if !isSetTimerButtonActive {
                            isStartButtonPressed.toggle()
                        }
                    })
                    .bold()
                    .font(.largeTitle)
                    .padding(20)
                    .background(.white)
                    .cornerRadius(15)
                    .foregroundColor(.indigo)
                    .shadow(color: .black, radius: 10)
                }
            }
            .padding(20.0)
            .background(.blue)
            .cornerRadius(15)
            .padding(20)
                
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
