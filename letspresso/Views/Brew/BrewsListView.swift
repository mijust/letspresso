//
//  BrewsListView.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//

import SwiftUI
import SwiftData

struct BrewsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Brew.date, order: .reverse) private var brews: [Brew]
    @State private var showingAddBrew = false
    @State private var selectedMethod: BrewMethod = .espresso
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.warmWhite.ignoresSafeArea()
                
                List {
                    ForEach(brews) { brew in
                        NavigationLink(destination: BrewDetailView(brew: brew)) {
                            BrewRowView(brew: brew)
                        }
                        .listRowBackground(Color.creamBackground)
                    }
                    .onDelete(perform: deleteBrews)
                }
                .scrollContentBackground(.hidden)
                .background(Color.warmWhite)
            }
            .navigationTitle("Brühungen")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.coffeeBrown, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(BrewMethod.allCases, id: \.self) { method in
                            Button(method.rawValue) {
                                selectedMethod = method
                                showingAddBrew = true
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.warmWhite)
                    }
                }
            }
            .sheet(isPresented: $showingAddBrew) {
                AddBrewView(method: selectedMethod)
            }
        }
    }
    
    func deleteBrews(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(brews[index])
        }
    }
}

struct BrewRowView: View {
    let brew: Brew
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Methode mit Icon
                HStack(spacing: 6) {
                    Image(systemName: methodIcon(for: brew.method))
                        .foregroundColor(.coffeeBrown)
                        .font(.caption)
                    Text(brew.method.rawValue)
                        .font(.headline)
                        .foregroundColor(.darkCoffeeBrown)
                }
                Spacer()
                Text(brew.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.coffeeBrown)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.lightCoffeeBrown.opacity(0.1))
                    .cornerRadius(6)
            }
            
            if let bean = brew.coffeeBean {
                Text("\(bean.name) - \(bean.roaster)")
                    .font(.subheadline)
                    .foregroundColor(.coffeeBrown)
            }
            
            HStack {
                // Parameter Display
                HStack(spacing: 4) {
                    Image(systemName: "scalemass")
                        .font(.caption2)
                        .foregroundColor(.beanGreen)
                    
                    if brew.method == .espresso {
                        Text(String(format: "%.1fg → %.1fg", brew.coffeeWeight, brew.yieldWeight ?? 0))
                            .font(.caption)
                            .foregroundColor(.darkCoffeeBrown)
                    } else {
                        Text(String(format: "%.1fg : %.0fg", brew.coffeeWeight, brew.waterWeight))
                            .font(.caption)
                            .foregroundColor(.darkCoffeeBrown)
                    }
                }
                
                Spacer()
                
                // Rating
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < brew.rating ? "star.fill" : "star")
                            .font(.caption2)
                            .foregroundColor(.ratingGold)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func methodIcon(for method: BrewMethod) -> String {
        switch method {
        case .espresso:
            return "cup.and.saucer.fill"
        case .v60:
            return "triangle"
        case .chemex:
            return "drop"
        case .kalitaWave:
            return "waveform"
        case .frenchPress:
            return "cylinder"
        case .aeropress:
            return "circle"
        }
    }
}
