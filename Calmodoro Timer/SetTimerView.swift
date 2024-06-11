//
//  SetTimerViewModel.swift
//  SwiftDataExample
//
//  Created by Jordon Bigelow on 6/10/24.
//

import SwiftUI

struct SetTimerView: View {
    @StateObject private var viewModel = TimerViewModel(seconds: 0, goalTime: 300)
    
    @State private var selectedMinute = 0
    @State private var selectedSecond = 0
    
    let minutes = Array(0..<60)
    let seconds = Array(0..<60)
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Picker(selection: $viewModel.selectedMinutes, label: Text("Minute")) {
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
                    Picker(selection: $viewModel.selectedSeconds, label: Text("Second")) {
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
}
