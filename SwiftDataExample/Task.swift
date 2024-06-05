//
//  Item.swift
//  SwiftDataExample
//
//  Created by Jordon Bigelow on 6/2/24.
//

import Foundation
import SwiftData

@Model
final class Task {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
