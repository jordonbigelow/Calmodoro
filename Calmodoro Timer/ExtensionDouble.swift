//
//  ExtensionDouble.swift
//  SwiftDataExample
//
//  Created by Jordon Bigelow on 6/4/24.
//

import Foundation

extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .second, .nanosecond]
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? ""
    }
}

