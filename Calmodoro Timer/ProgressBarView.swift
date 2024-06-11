//
//  ProgressBar.swift
//  SwiftDataExample
//
//  Created by Jordon Bigelow on 6/4/24.
//

import SwiftUI

struct ProgressBarView: View {
    // MARK: - Binding properties
    @Binding var progress: TimeInterval
    @Binding var goal: Double
    
    // MARK: - View Body
    var body: some View {
        ZStack {
            // Default Circle
            defaultCircle
            // Overlap Circle
            progressCircle
        }
    }
    
    private var defaultCircle: some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .butt, dash: [3, 6]))
            .fill(.gray)
            .rotationEffect(Angle(degrees: -90))
            .frame(width: 250, height: 250)
    }
    
    private var progressCircle: some View {
        Circle()
            .trim(from: 0.0, to: CGFloat(progress) / CGFloat(goal))
            .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .butt, dash: [3,6]))
            .fill(.yellow)
            .animation(.spring(), value: progress)
            .rotationEffect(Angle(degrees: -90))
            .frame(width: 250, height: 250)
    }
}

