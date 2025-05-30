//
//  BrewDetailView.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//

import SwiftUI
import SwiftData

struct BrewDetailView: View {
    let brew: Brew
    
    var body: some View {
        ZStack {
            CoffeeTheme.primaryBackground.ignoresSafeArea() // Hintergrund
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Coffee Bean Info
                    if let bean = brew.coffeeBean {
                        BrewDetailGroupBox(title: "Bohne", icon: "leaf.fill") {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(bean.name)
                                    .font(.headline)
                                    .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
                                Text("\(bean.roaster) - \(bean.origin)")
                                    .font(.subheadline)
                                    .foregroundColor(CoffeeTheme.secondaryText) // Sekundäre Textfarbe
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    // Brew Parameters
                    BrewDetailGroupBox(title: "Parameter", icon: "gearshape.fill") {
                        VStack(spacing: 12) {
                            DetailRow(label: "Methode", value: brew.method.rawValue)
                            DetailRow(label: "Kaffee", value: String(format: "%.1fg", brew.coffeeWeight))
                            
                            if brew.method == .espresso {
                                DetailRow(label: "Yield", value: String(format: "%.1fg", brew.yieldWeight ?? 0))
                                DetailRow(label: "Ratio", value: String(format: "1:%.1f", brew.ratio))
                                if let time = brew.extractionTime {
                                    DetailRow(label: "Zeit", value: "\(Int(time))s")
                                }
                            } else {
                                DetailRow(label: "Wasser", value: String(format: "%.0fg", brew.waterWeight))
                                DetailRow(label: "Ratio", value: String(format: "1:%.1f", brew.ratio))
                            }
                            
                            DetailRow(label: "Temperatur", value: String(format: "%.0f°C", brew.waterTemperature))
                            DetailRow(label: "Mahlgrad", value: brew.grindSize.rawValue)
                        }
                    }
                    
                    // Taste Profile
                    BrewDetailGroupBox(title: "Geschmacksprofil", icon: "heart.fill") {
                        VStack(spacing: 12) {
                            RatingRow(label: "Gesamt", value: brew.rating)
                            RatingRow(label: "Säure", value: brew.acidity)
                            RatingRow(label: "Süße", value: brew.sweetness)
                            RatingRow(label: "Bitterkeit", value: brew.bitterness)
                            RatingRow(label: "Körper", value: brew.body)
                        }
                    }
                    
                    // Tasting Notes
                    if !brew.tastingNotes.isEmpty {
                        BrewDetailGroupBox(title: "Verkostungsnotizen", icon: "note.text") {
                            Text(brew.tastingNotes)
                                .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(brew.date.formatted(date: .abbreviated, time: .shortened))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(CoffeeTheme.primaryButton, for: .navigationBar) // Toolbar-Hintergrund
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

// MARK: - Supporting Views

struct BrewDetailGroupBox<Content: View>: View {
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
                    .foregroundColor(CoffeeTheme.secondaryText) // Sekundäre Textfarbe für Icons
                Text(title)
                    .font(.headline)
                    .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
            }
            
            content
        }
        .padding(16)
        .background(CoffeeTheme.cardBackground) // Kartenhintergrund
        .cornerRadius(12)
        .shadow(color: CoffeeTheme.primaryButton.opacity(0.1), radius: 4, x: 0, y: 2) // Schattenfarbe
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            HStack {
                Circle()
                    .fill(CoffeeTheme.secondaryButton) // Füllfarbe des Kreises
                    .frame(width: 6, height: 6)
                Text(label)
                    .foregroundColor(CoffeeTheme.secondaryText) // Sekundäre Textfarbe
            }
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
        }
    }
}

struct RatingRow: View {
    let label: String
    let value: Int
    
    var body: some View {
        HStack {
            HStack {
                Circle()
                    .fill(CoffeeTheme.accent) // Füllfarbe des Kreises
                    .frame(width: 6, height: 6)
                Text(label)
                    .foregroundColor(CoffeeTheme.secondaryText) // Sekundäre Textfarbe
            }
            Spacer()
            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Image(systemName: index < value ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundColor(CoffeeTheme.accent) // Akzentfarbe für Sterne
                }
            }
        }
    }
}
