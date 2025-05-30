//
//  TimerView.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//

import SwiftUI

struct TimerView: View {
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var isRunning = false
    @State private var intervals: [TimeInterval] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                // Timer Display
                Text(timeString(from: elapsedTime))
                    .font(.system(size: 60, weight: .thin, design: .monospaced))
                    .padding()
                
                // Control Buttons
                HStack(spacing: 30) {
                    Button(action: toggleTimer) {
                        Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(isRunning ? .orange : .green)
                    }
                    
                    Button(action: lap) {
                        Image(systemName: "flag.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                    }
                    .disabled(!isRunning)
                    
                    Button(action: reset) {
                        Image(systemName: "stop.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                    }
                }
                
                // Intervals
                List(intervals.indices, id: \.self) { index in
                    HStack {
                        Text("Intervall \(index + 1)")
                        Spacer()
                        Text(timeString(from: intervals[index]))
                            .font(.system(.body, design: .monospaced))
                    }
                }
            }
            .navigationTitle("Brew Timer")
        }
    }
    
    func toggleTimer() {
        isRunning.toggle()
        if isRunning {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                elapsedTime += 0.01
            }
        } else {
            timer?.invalidate()
        }
    }
    
    func lap() {
        intervals.append(elapsedTime)
    }
    
    func reset() {
        timer?.invalidate()
        isRunning = false
        elapsedTime = 0
        intervals = []
    }
    
    func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let hundredths = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }
}
