//
//  StatsView.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//

import SwiftUI
import SwiftData

// StatsView hier

struct StatsView: View {
    @Query private var brews: [Brew]
    @Query private var beans: [CoffeeBean]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Übersicht
                    GroupBox("Übersicht") {
                        VStack(spacing: 10) {
                            StatRow(label: "Gesamte Brühungen", value: "\(brews.count)")
                            StatRow(label: "Verschiedene Bohnen", value: "\(beans.count)")
                            StatRow(label: "Lieblings-Methode", value: favoriteMethod)
                        }
                    }
                    
                    // Durchschnittswerte
                    GroupBox("Durchschnitte") {
                        VStack(spacing: 10) {
                            StatRow(label: "Bewertung", value: String(format: "%.1f ⭐", averageRating))
                            StatRow(label: "Espresso Ratio", value: String(format: "1:%.1f", averageEspressoRatio))
                            StatRow(label: "Kaffee pro Brühung", value: String(format: "%.1fg", averageCoffeePerBrew))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Statistiken")
        }
    }
    
    var favoriteMethod: String {
        let methodCounts = Dictionary(grouping: brews, by: { $0.method })
            .mapValues { $0.count }
        return methodCounts.max(by: { $0.value < $1.value })?.key.rawValue ?? "N/A"
    }
    
    var averageRating: Double {
        guard !brews.isEmpty else { return 0 }
        return Double(brews.reduce(0) { $0 + $1.rating }) / Double(brews.count)
    }
    
    var averageEspressoRatio: Double {
        let espressoBrews = brews.filter { $0.method == .espresso }
        guard !espressoBrews.isEmpty else { return 0 }
        return espressoBrews.reduce(0) { $0 + $1.ratio } / Double(espressoBrews.count)
    }
    
    var averageCoffeePerBrew: Double {
        guard !brews.isEmpty else { return 0 }
        return brews.reduce(0) { $0 + $1.coffeeWeight } / Double(brews.count)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}
