//
//  StatsView.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Query private var brews: [Brew]
    @Query private var beans: [CoffeeBean]
    
    var body: some View {
        NavigationStack {
            ZStack {
                CoffeeTheme.primaryBackground.ignoresSafeArea() // Hintergrund
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Übersicht
                        StatsGroupBox(title: "Übersicht", icon: "chart.bar.fill") {
                            VStack(spacing: 12) {
                                StatRow(label: "Gesamte Brühungen", value: "\(brews.count)", color: Color.mediumBrown) // Angepasst
                                StatRow(label: "Verschiedene Bohnen", value: "\(beans.count)", color: Color.accentGreen) // Angepasst
                                StatRow(label: "Lieblings-Methode", value: favoriteMethod, color: CoffeeTheme.accent) // Angepasst
                            }
                        }
                        
                        // Durchschnittswerte
                        StatsGroupBox(title: "Durchschnitte", icon: "target") {
                            VStack(spacing: 12) {
                                StatRow(label: "Bewertung", value: String(format: "%.1f ⭐", averageRating), color: CoffeeTheme.accent) // Angepasst
                                StatRow(label: "Espresso Ratio", value: String(format: "1:%.1f", averageEspressoRatio), color: Color.lightBrown) // Angepasst
                                StatRow(label: "Durchschnittl. Kaffee pro Brühung", value: String(format: "%.1fg", averageCoffeePerBrew), color: CoffeeTheme.primaryText) // Angepasst
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Statistiken")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(CoffeeTheme.primaryButton, for: .navigationBar) // Toolbar-Hintergrund
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    private var averageRating: Double {
        guard !brews.isEmpty else { return 0 }
        return Double(brews.reduce(0) { $0 + $1.rating }) / Double(brews.count)
    }
    
    private var favoriteMethod: String {
        guard !brews.isEmpty else { return "N/A" }
        let methodCounts = Dictionary(grouping: brews, by: { $0.method })
            .mapValues { $0.count }
        
        if let (method, _) = methodCounts.max(by: { $0.value < $1.value }) {
            return method.rawValue
        }
        return "N/A"
    }
    
    private var averageEspressoRatio: Double {
        let espressoBrews = brews.filter { $0.method == .espresso && $0.yieldWeight != nil }
        guard !espressoBrews.isEmpty else { return 0 }
        return espressoBrews.reduce(0) { $0 + $1.ratio } / Double(espressoBrews.count)
    }
    
    private var averageCoffeePerBrew: Double {
        guard !brews.isEmpty else { return 0 }
        return brews.reduce(0) { $0 + $1.coffeeWeight } / Double(brews.count)
    }
}

struct StatsGroupBox<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(CoffeeTheme.secondaryText) // Angepasst
                Text(title)
                    .font(.headline)
                    .foregroundColor(CoffeeTheme.primaryText) // Angepasst
            }
            
            content
        }
        .padding(16)
        .background(CoffeeTheme.cardBackground) // Angepasst
        .cornerRadius(12)
        .shadow(color: CoffeeTheme.primaryButton.opacity(0.1), radius: 4, x: 0, y: 2) // Angepasst
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                Text(label)
                    .foregroundColor(CoffeeTheme.secondaryText) // Angepasst
            }
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(CoffeeTheme.primaryText) // Angepasst
        }
    }
}
