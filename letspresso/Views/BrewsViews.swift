//
//  BrewsViews.swift
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
            List {
                ForEach(brews) { brew in
                    NavigationLink(destination: BrewDetailView(brew: brew)) {
                        BrewRowView(brew: brew)
                    }
                }
                .onDelete(perform: deleteBrews)
            }
            .navigationTitle("Brühungen")
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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(brew.method.rawValue)
                    .font(.headline)
                Spacer()
                Text(brew.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let bean = brew.coffeeBean {
                Text("\(bean.name) - \(bean.roaster)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                if brew.method == .espresso {
                    Text("\(brew.coffeeWeight, specifier: "%.1f")g → \(brew.yieldWeight ?? 0, specifier: "%.1f")g")
                        .font(.caption)
                } else {
                    Text("\(brew.coffeeWeight, specifier: "%.1f")g : \(brew.waterWeight, specifier: "%.0f")g")
                        .font(.caption)
                }
                
                Spacer()
                
                ForEach(0..<5) { index in
                    Image(systemName: index < brew.rating ? "star.fill" : "star")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
