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
                Color.warmWhite.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Übersicht
                        StatsGroupBox(title: "Übersicht", icon: "chart.bar.fill") {
                            VStack(spacing: 12) {
                                StatRow(label: "Gesamte Brühungen", value: "\(brews.count)", color: .coffeeBrown)
                                StatRow(label: "Verschiedene Bohnen", value: "\(beans.count)", color: .beanGreen)
                                StatRow(label: "Lieblings-Methode", value: favoriteMethod, color: .espressoGold)
                            }
                        }
                        
                        // Durchschnittswerte
                        StatsGroupBox(title: "Durchschnitte", icon: "target") {
                            VStack(spacing: 12) {
                                StatRow(label: "Bewertung", value: String(format: "%.1f ⭐", averageRating), color: .ratingGold)
                                StatRow(label: "Espresso Ratio", value: String(format: "1:%.1f", averageEspressoRatio), color: .lightCoffeeBrown)
                                StatRow(label: "Kaffee pro Brühung", value: String(format: "%.1fg", averageCoffeePerBrew), color: .darkCoffeeBrown)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Statistiken")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.coffeeBrown, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
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
                    .foregroundColor(.coffeeBrown)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.darkCoffeeBrown)
            }
            
            content
        }
        .padding(16)
        .background(Color.creamBackground)
        .cornerRadius(12)
        .shadow(color: .coffeeBrown.opacity(0.1), radius: 4, x: 0, y: 2)
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
                    .foregroundColor(.coffeeBrown)
            }
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(.darkCoffeeBrown)
        }
    }
}
