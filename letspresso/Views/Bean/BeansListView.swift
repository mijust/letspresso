//
//  BeansListView.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//

import SwiftUI
import SwiftData

struct BeansListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CoffeeBean.purchaseDate, order: .reverse) private var beans: [CoffeeBean]
    @State private var showingAddBean = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                CoffeeTheme.primaryBackground.ignoresSafeArea() // Hintergrund
                
                List {
                    ForEach(beans) { bean in
                        NavigationLink(destination:  BeanDetailView(bean: bean)) {
                            BeanRowView(bean: bean)
                        }
                        .listRowBackground(CoffeeTheme.cardBackground) // Listenreihen-Hintergrund
                    }
                    .onDelete(perform: deleteBeans)
                }
                .scrollContentBackground(.hidden)
                .background(CoffeeTheme.primaryBackground) // Hintergrund
            }
            .navigationTitle("Meine Bohnen")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(CoffeeTheme.primaryButton, for: .navigationBar) // Toolbar-Hintergrund
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddBean = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(CoffeeTheme.primaryButtonText) // Toolbar-Textfarbe
                    }
                }
            }
            .sheet(isPresented: $showingAddBean) {
                AddBeanView()
            }
        }
    }
    
    func deleteBeans(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(beans[index])
        }
    }
}

struct BeanRowView: View {
    let bean: CoffeeBean
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(bean.name)
                .font(.headline)
                .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
            
            HStack {
                Text(bean.roaster)
                    .font(.subheadline)
                    .foregroundColor(CoffeeTheme.secondaryText) // Sekundäre Textfarbe
                Spacer()
                Text("\(bean.pricePerKg, specifier: "%.2f") €/kg")
                    .font(.caption)
                    .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(CoffeeTheme.accent.opacity(0.2)) // Akzentfarbe mit Opazität
                    .cornerRadius(8)
            }
            
            HStack {
                ForEach(0..<5) { index in
                    Image(systemName: index < bean.rating ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundColor(CoffeeTheme.accent) // Akzentfarbe für Sterne
                }
                Spacer()
                Text(bean.origin)
                    .font(.caption2)
                    .foregroundColor(Color.accentGreen) // Akzentfarbe
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.accentGreen.opacity(0.1)) // Akzentfarbe mit Opazität
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 8)
    }
}
