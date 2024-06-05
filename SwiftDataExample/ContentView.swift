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
    @ObservedObject var timerViewModel: TimerViewModel
    @Query private var items: [Task]
    
    @State var pomodoroTimer = Date()
    @State var pomodoroTimerInSeconds: Double = 1500
    @State var breakTimer = Date()
    @State var breakTimerInSeconds: Double = 300
    
    @State var isPomodoroDatePickerVisible = false
    @State var isPomodoroTimerActive = true
    
    @State var isBreakTimerActive = false
    @State var isBreakDatePickerVisible = false
    
    @State var isSetTimerButtonActive = false
    
    @State var isPaused = false
    @State var isStartButtonPressed = false
    @State private var rotation = 0
    
    // MARK: - Initializer
    init(seconds: TimeInterval = 0) {
        timerViewModel = TimerViewModel(seconds: seconds, goalTime: 300)
    }
    
    var body: some View {
        // MARK: - Timer View
        VStack {
            
            VStack {
                Text("Calmodoro Timer")
                    .font(.title)
                topButtons
                ZStack {
                    ProgressBarView(progress: $timerViewModel.seconds, goal: $timerViewModel.goalTime)
                        .padding(20)
                    if !isSetTimerButtonActive{
                        timerText
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
                }
                
                // MARK: - Bottom Buttons
                if !isSetTimerButtonActive {
                    HStack {
                        startPauseButton
                            .bold()
                            .font(.headline)
                            .padding(10)
                            .background(.white)
                            .cornerRadius(15)
                            .foregroundColor(.indigo)
                            .shadow(color: .black, radius: 5)
                        resetButton
                            .bold()
                            .font(.headline)
                            .padding(10)
                            .background(.white)
                            .cornerRadius(15)
                            .foregroundColor(.indigo)
                            .shadow(color: .black, radius: 5)
                    }
                }
            }
            .padding(15)
            .background(.blue)
            .cornerRadius(15)
            .padding(20)
           
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
    // MARK: - Private Views
    private var timerText: some View {
        VStack {
            Text(timerViewModel.progress >= 1 ? "DONE" : timerViewModel.displayTime)
                .font(.largeTitle)
                .foregroundColor(.black)
        }
    }
    
    private var topButtons: some View {
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
    }
    
    private var resetButton: some View {
        Button {
            reset()
        } label: {
            HStack(spacing: 0) {
                Image(systemName: "arrow.clockwise")
                    .rotationEffect(.degrees(Double(rotation)))
                Text("Reset")
            }
        }
    }
    
    private var startPauseButton: some View {
        Button {
            if timerViewModel.progress < 1 {
                isPaused.toggle()
                isPaused ? timerViewModel.pauseSession() : timerViewModel.startSession()
            }
        } label: {
            HStack {
                Image(systemName: isPaused ? "play.fill" : "pause.fill")
                Text(isPaused ? "Start" : "Pause")
            }
        }
    }
    // MARK: - Private Methods
    
    private func reset() {
        withAnimation(.easeInOut(duration: 0.4)) {
            rotation += 360
        }
        
        if timerViewModel.progress >= 1 {
            timerViewModel.resetTimer()
            timerViewModel.startSession()
        } else {
            timerViewModel.resetTimer()
            timerViewModel.displayTime = "00:00"
        }
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
