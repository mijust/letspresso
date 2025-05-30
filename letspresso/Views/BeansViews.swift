//
//  BeansViews.swift.swift
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
            List {
                ForEach(beans) { bean in
                    NavigationLink(destination: BeanDetailView(bean: bean)) {
                        BeanRowView(bean: bean)
                    }
                }
                .onDelete(perform: deleteBeans)
            }
            .navigationTitle("Meine Bohnen")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddBean = true }) {
                        Image(systemName: "plus")
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
        VStack(alignment: .leading, spacing: 4) {
            Text(bean.name)
                .font(.headline)
            HStack {
                Text(bean.roaster)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(bean.pricePerKg, specifier: "%.2f") €/kg")
                    .font(.caption)
            }
            HStack {
                ForEach(0..<5) { index in
                    Image(systemName: index < bean.rating ? "star.fill" : "star")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

