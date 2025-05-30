import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BeansListView()
                .tabItem {
                    Label("Bohnen", systemImage: "leaf.fill")
                }
                .tag(0)
            
            BrewsListView()
                .tabItem {
                    Label("Brühungen", systemImage: "cup.and.saucer.fill")
                }
                .tag(1)
            
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
                .tag(2)
            
            StatsView()
                .tabItem {
                    Label("Statistik", systemImage: "chart.bar.fill")
                }
                .tag(3)
        }
    }
}
