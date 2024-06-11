//
//  TimerView.swift
//  Calmodoro Timer
//
//  Created by Jordon Bigelow on 6/11/24.
//

import SwiftUI

struct TimerView: View {
    // MARK: - Properties
    @ObservedObject var pomodoroTimerViewModel: TimerViewModel = TimerViewModel(seconds: 0, goalTime: 1500)
    @ObservedObject var breakTimerViewModel: TimerViewModel = TimerViewModel(seconds: 0, goalTime: 300)
    @State var isPomodoroTimerActive = true
    @State var isBreakTimerActive = false
    @State var isSetTimerButtonActive = false
    @State var isPaused = true
    @State private var rotation = 0
    @State private var selectedMinute = 0
    @State private var selectedSecond = 0
   
    // These are used for the Picker values to display minutes and seconds
    let minutes = Array(0..<60)
    let seconds = Array(0..<60)
    
    // MARK: - Main View Body
    var body: some View {
        VStack {
            VStack {
                Text("Calmodoro Timer")
                    .font(.title)
                topButtons
                ZStack {
                    ProgressBarView(progress: isPomodoroTimerActive ? $pomodoroTimerViewModel.seconds : $breakTimerViewModel.seconds, 
                                    goal: isPomodoroTimerActive ? $pomodoroTimerViewModel.goalTime : $breakTimerViewModel.goalTime)
                        .padding(20)
                    if !isSetTimerButtonActive {
                        timerText
                    }
                    
                    if (isPomodoroTimerActive || isBreakTimerActive) && isSetTimerButtonActive {
                        setTimerView
                    }
                }
                
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
        }
    }
    
    // MARK: - TopButtons View
    private var topButtons: some View {
        HStack {
            if isPaused {
                Button("Pomodoro", action: {
                    isPomodoroTimerActive = true
                    isBreakTimerActive = false
                })
                .padding(5)
                .background(isPomodoroTimerActive ? .yellow: .white)
                .cornerRadius(5)
                .shadow(radius: isPomodoroTimerActive ? 5 : 0)
                
                Button("Break", action: {
                    isBreakTimerActive = true
                    isPomodoroTimerActive = false
                })
                .padding(5)
                .background(isBreakTimerActive ? .yellow: .white)
                .cornerRadius(5)
                .shadow(radius: isBreakTimerActive ? 5 : 0)
                
                Button("Set Timer", action: {
                    isSetTimerButtonActive.toggle()
                    if !isSetTimerButtonActive {
                        setTimer()
                    }
                })
                .padding(5)
                .background(isSetTimerButtonActive ? .yellow: .white)
                .cornerRadius(5)
                .shadow(radius: isSetTimerButtonActive ? 5 : 0)
            }
        }
        .foregroundColor(.indigo)
    }
    // MARK: - StartPause Button View
    private var startPauseButton: some View {
        Button {
            if pomodoroTimerViewModel.progress < 1 && isPomodoroTimerActive {
                isPaused.toggle()
                isPaused ? pomodoroTimerViewModel.pauseSession() : pomodoroTimerViewModel.startSession()
            } else if breakTimerViewModel.progress < 1 && isBreakTimerActive {
                isPaused.toggle()
                isPaused ? breakTimerViewModel.pauseSession() : breakTimerViewModel.startSession()
            }
        } label: {
            HStack {
                Image(systemName: isPaused ? "play.fill" : "pause.fill")
                Text(isPaused ? "Start" : "Pause")
            }
        }
    }
    
    // MARK: - Reset Button View
    private var resetButton: some View {
        Button {
            reset(timerViewModel: isPomodoroTimerActive ? pomodoroTimerViewModel : breakTimerViewModel, rotation: rotation)
        } label: {
            HStack(spacing: 0) {
                Image(systemName: "arrow.clockwise")
                    .rotationEffect(.degrees(Double(rotation)))
                Text("Reset")
            }
        }
    }
    
    // MARK: - Timer Display Text View
    private var timerText: some View {
        VStack {
            if isPomodoroTimerActive {
                Text(pomodoroTimerViewModel.progress >= 1 ? "DONE" : pomodoroTimerViewModel.displayTime)
                    .font(.largeTitle)
                    .foregroundColor(.black)
            } else if isBreakTimerActive {
                Text(breakTimerViewModel.progress >= 1 ? "DONE" : breakTimerViewModel.displayTime)
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
        }
    }
    
    // MARK: - SetTimerView
    var setTimerView: some View {
        VStack {
            HStack {
                HStack {
                    Picker(selection: isPomodoroTimerActive ? $pomodoroTimerViewModel.selectedMinutes : $breakTimerViewModel.selectedMinutes, label: Text("Minute")) {
                        ForEach(minutes, id: \.self) { minute in
                            Text("\(minute)").tag(minute)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 45)
                    .clipped()
                    
                    Text("Min")
                }
                
                HStack {
                    Picker(selection: isPomodoroTimerActive ? $pomodoroTimerViewModel.selectedSeconds : $breakTimerViewModel.selectedSeconds, label: Text("Second")) {
                        ForEach(seconds, id: \.self) { second in
                            Text("\(second)").tag(second)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 45)
                    .clipped()
                    
                    Text("Sec")
                }
            }
            .font(.caption2)
            .padding()
        }
    }
    
    // MARK: - Private Methods
    private func reset(timerViewModel: TimerViewModel, rotation: Int) {
        withAnimation(.easeInOut(duration: 0.4)) {
            self.rotation += 360
        }
        
        if timerViewModel.progress >= 1 {
            timerViewModel.resetTimer()
            timerViewModel.startSession()
        } else {
            timerViewModel.resetTimer()
            timerViewModel.displayTime = "00:00"
        }
    }
   
    private func setTimer() {
        if isPomodoroTimerActive {
            pomodoroTimerViewModel.updateGoalTime()
        } else if isBreakTimerActive {
            breakTimerViewModel.updateGoalTime()
        }
    }
}
