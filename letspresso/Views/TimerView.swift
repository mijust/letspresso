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
            ZStack {
                CoffeeTheme.primaryBackground.ignoresSafeArea()
                
                VStack(spacing: 40) {
                    TimerDisplayView(elapsedTime: elapsedTime)
                    
                    TimerControlButtonsView(
                        isRunning: isRunning,
                        toggleAction: toggleTimer,
                        lapAction: lap,
                        resetAction: reset
                    )
                    
                    if !intervals.isEmpty {
                        IntervalsListView(intervals: intervals)
                    }
                }
                .padding()
            }
            .navigationTitle("Brüh-Timer")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(CoffeeTheme.primaryButton, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onDisappear(perform: { timer?.invalidate() }) // Stoppt den Timer, wenn die View verschwindet
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
}

// MARK: - Unteransichten für TimerView

struct TimerDisplayView: View {
    let elapsedTime: TimeInterval
    
    var body: some View {
        Text(timeString(from: elapsedTime))
            .font(.system(size: 60, weight: .thin, design: .monospaced))
            .foregroundColor(CoffeeTheme.primaryText)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(CoffeeTheme.cardBackground)
                    .shadow(color: CoffeeTheme.primaryButton.opacity(0.1), radius: 5, x: 0, y: 2)
            )
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let hundredths = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }
}

struct TimerControlButtonsView: View {
    let isRunning: Bool
    let toggleAction: () -> Void
    let lapAction: () -> Void
    let resetAction: () -> Void
    
    var body: some View {
        HStack(spacing: 30) {
            Button(action: toggleAction) {
                Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(isRunning ? CoffeeTheme.warning : Color.accentGreen)
            }
            
            Button(action: lapAction) {
                Image(systemName: "flag.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color.accentGold)
            }
            .disabled(!isRunning)
            .opacity(isRunning ? 1.0 : 0.5)
            
            Button(action: resetAction) {
                Image(systemName: "stop.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color.errorRed)
            }
        }
    }
}

struct IntervalsListView: View {
    let intervals: [TimeInterval]
    
    var body: some View {
        List { // Angepasster List Initialisierer
            ForEach(Array(intervals.enumerated()), id: \.offset) { offset, element in // ForEach korrigiert, um enumerated() zu verwenden
                HStack {
                    Text("Intervall \(offset + 1)") // offset für den Index verwenden
                        .foregroundColor(CoffeeTheme.primaryText)
                    Spacer()
                    Text(timeString(from: element)) // element direkt verwenden
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(Color.mediumBrown)
                }
                .listRowBackground(CoffeeTheme.cardBackground)
            }
        }
        .scrollContentBackground(.hidden)
        .background(CoffeeTheme.primaryBackground)
        .frame(maxHeight: 200)
        .cornerRadius(12)
        .shadow(color: CoffeeTheme.primaryButton.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let hundredths = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }
}
