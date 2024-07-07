//
//  TimerViewModel.swift
//  Calmodoro Timer App
//
//  Created by Jordon Bigelow on 6/4/24.
//

import SwiftUI
import AudioToolbox
import AVFoundation

class TimerViewModel: NSObject, ObservableObject {
    // MARK: - Published properties
    @Published var selectedMinutes: Int = 5
    @Published var selectedSeconds: Int = 0
    @Published var progress: Double
    @Published var seconds: TimeInterval
    @Published var displayTime: String = ""
    @Published var goalTime: Double = 0
    
    
    // MARK: - Private properties
    private var timer: Timer = Timer()
    private var soundId: SystemSoundID = 1407
    private let feedback = UIImpactFeedbackGenerator(style: .soft)
    
    // MARK: - Initializer
    init(seconds: TimeInterval, goalTime: Double) {
        self.seconds = seconds
        self.goalTime = goalTime
        self.progress = seconds / Double(goalTime)
    }
    
    // MARK: - Timer Public Methods
    @objc func fireTimer() {
        seconds += 0.2
        progress = Double(seconds) / Double(goalTime)
        self.displayTime = calculateDisplayTime()
        
        // Timer is completed
        if progress >= 1 {
            stopSession()
            makeSoundAndVibration()
        }
    }
    
    func startSession() {
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func stopSession() {
        timer.invalidate()
    }
    
    func pauseSession() {
        timer.invalidate()
    }
    
    func resetTimer() {
        seconds = 0
        progress = 0
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        self.progress = seconds / Double(goalTime)
        self.displayTime = calculateDisplayTime()
    }
    
    func updateGoalTime() {
        self.goalTime = Double(selectedMinutes * 60) + Double(selectedSeconds)
    }
    
    // MARK: - Private Methods
    private func calculateDisplayTime() -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
   
    private func makeSoundAndVibration() {
        AudioServicesPlayAlertSoundWithCompletion(soundId, nil)
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), {})
    }
}
