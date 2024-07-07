//
//  CalmodoroTimerApp.swift
//  CalmodoroTimerApp
//
//  Created by Jordon Bigelow on 6/2/24.
//

import SwiftUI
import SwiftData

@main
struct CalmodoroTimer: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Task.self, CompletedTask.self])
    }
}
