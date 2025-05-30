//
//  BeanDetailView.swift
//  letspresso
//
//  Created by Michael on 30.05.25.


import SwiftUI
import SwiftData

struct BeanDetailView: View {
    let bean: CoffeeBean
    
    var body: some View {
        ZStack {
            Color.warmWhite.ignoresSafeArea() //
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Basic Information
                    BrewDetailGroupBox(title: "Basis Informationen", icon: "info.circle.fill") { //
                        VStack(spacing: 12) {
                            DetailRow(label: "Name", value: bean.name) //
                            DetailRow(label: "Röster", value: bean.roaster) //
                            DetailRow(label: "Herkunft", value: bean.origin) //
                            DetailRow(label: "Röstgrad", value: bean.roastLevel.rawValue) //
                            DetailRow(label: "Preis pro kg", value: String(format: "%.2f €", bean.pricePerKg)) //
                        }
                    }
                    
                    // Roast Date
                    BrewDetailGroupBox(title: "Röstdatum", icon: "calendar") { //
                        VStack(spacing: 12) {
                            if let roastDate = bean.roastDate {
                                DetailRow(label: "Datum", value: roastDate.formatted(date: .abbreviated, time: .omitted)) //
                            } else {
                                Text("Nicht bekannt")
                                    .foregroundColor(.coffeeBrown) //
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                    // Rating
                    BrewDetailGroupBox(title: "Bewertung", icon: "star.fill") { //
                        RatingRow(label: "Gesamt", value: bean.rating) //
                    }
                    
                    // Notes
                    if !bean.notes.isEmpty {
                        BrewDetailGroupBox(title: "Notizen", icon: "note.text") { //
                            Text(bean.notes)
                                .foregroundColor(.darkCoffeeBrown) //
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(bean.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.coffeeBrown, for: .navigationBar) //
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
