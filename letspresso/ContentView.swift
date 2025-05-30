//
//  ContentView.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BeansListView()
                .tabItem {
                    Label("Beans", systemImage: "leaf.fill")
                }
                .tag(0)
            
            BrewsListView()
                .tabItem {
                    Label("Brews", systemImage: "cup.and.saucer.fill")
                }
                .tag(1)
            
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
                .tag(2)
            
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(3)
        }
        .accentColor(CoffeeTheme.primaryButton) // Tab-Auswahl Farbe
        .background(CoffeeTheme.primaryBackground) // Hintergrundfarbe der Tab-Ansicht
    }
}
