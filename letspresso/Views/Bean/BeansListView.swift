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
                Color.warmWhite.ignoresSafeArea()
                
                List {
                    ForEach(beans) { bean in
                        NavigationLink(destination:  BeanDetailView(bean: bean)) { //noch anpassen
                            BeanRowView(bean: bean)
                        }
                        .listRowBackground(Color.creamBackground)
                    }
                    .onDelete(perform: deleteBeans)
                }
                .scrollContentBackground(.hidden)
                .background(Color.warmWhite)
            }
            .navigationTitle("Meine Bohnen")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.coffeeBrown, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddBean = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.warmWhite)
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
                .foregroundColor(.darkCoffeeBrown)
            
            HStack {
                Text(bean.roaster)
                    .font(.subheadline)
                    .foregroundColor(.coffeeBrown)
                Spacer()
                Text("\(bean.pricePerKg, specifier: "%.2f") €/kg")
                    .font(.caption)
                    .foregroundColor(.darkCoffeeBrown)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.espressoGold.opacity(0.2))
                    .cornerRadius(8)
            }
            
            HStack {
                ForEach(0..<5) { index in
                    Image(systemName: index < bean.rating ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundColor(.ratingGold)
                }
                Spacer()
                Text(bean.origin)
                    .font(.caption2)
                    .foregroundColor(.beanGreen)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.beanGreen.opacity(0.1))
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 8)
    }
}
