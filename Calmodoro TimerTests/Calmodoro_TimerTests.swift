//
//  Calmodoro_TimerTests.swift
//  Calmodoro TimerTests
//
//  Created by Jordon Bigelow on 7/14/24.
//

import XCTest
@testable import Calmodoro_Timer

final class Calmodoro_TimerTests: XCTestCase {
    let pomodoroTimerTestInstance = TimerViewModel(seconds: 0.2, goalTime: 60)

    func testUpdateGoalTime() throws {
        pomodoroTimerTestInstance.selectedMinutes = 4
        pomodoroTimerTestInstance.selectedSeconds = 0
        pomodoroTimerTestInstance.updateGoalTime()
        
        // update goaltime converts minutes and seconds into just seconds
        // This asserts that the method's math is working correctly.
        XCTAssertTrue(pomodoroTimerTestInstance.goalTime == 180)
    }
}
