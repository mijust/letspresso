//
//  AddBrewView.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//

import SwiftUI
import SwiftData

struct AddBrewView: View {
    let method: BrewMethod
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var coffeeWeight = 18.0
    @State private var waterWeight = 250.0
    @State private var grindSize: GrindSize = .fine
    @State private var waterTemperature = 93.0
    @State private var rating = 3
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.warmWhite.ignoresSafeArea()
                
                Form {
                    Section {
                        ParameterRow(
                            label: "Kaffee",
                            value: $coffeeWeight,
                            unit: "g",
                            icon: "leaf.fill",
                            color: .beanGreen
                        )
                        
                        ParameterRow(
                            label: "Wasser",
                            value: $waterWeight,
                            unit: "g",
                            icon: "drop.fill",
                            color: .blue.opacity(0.7)
                        )
                        
                        ParameterRow(
                            label: "Temperatur",
                            value: $waterTemperature,
                            unit: "°C",
                            icon: "thermometer",
                            color: .warningOrange
                        )
                        
                        // Grind Size Picker
                        HStack {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.coffeeBrown)
                                .frame(width: 20)
                            Picker("Mahlgrad", selection: $grindSize) {
                                ForEach(GrindSize.allCases, id: \.self) { size in
                                    Text(size.rawValue).tag(size)
                                }
                            }
                        }
                        
                    } header: {
                        Text("Parameter")
                            .foregroundColor(.coffeeBrown)
                    }
                    .listRowBackground(Color.creamBackground)
                    
                    Section {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.ratingGold)
                                .frame(width: 20)
                            Text("Gesamt")
                                .foregroundColor(.darkCoffeeBrown)
                            Spacer()
                            Picker("Gesamt", selection: $rating) {
                                ForEach(1...5, id: \.self) { value in
                                    HStack {
                                        Text("\(value)")
                                        Image(systemName: "star.fill")
                                    }.tag(value)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 200)
                        }
                    } header: {
                        Text("Bewertung")
                            .foregroundColor(.coffeeBrown)
                    }
                    .listRowBackground(Color.creamBackground)
                }
                .scrollContentBackground(.hidden)
                .background(Color.warmWhite)
            }
            .navigationTitle("Neue \(method.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.coffeeBrown, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                    .foregroundColor(.warmWhite)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Speichern") {
                        saveBasicBrew()
                    }
                    .foregroundColor(.warmWhite)
                    .fontWeight(.semibold)
                }
            }
        }
        .accentColor(.coffeeBrown)
    }
    
    private func saveBasicBrew() {
        let brew = Brew(
            method: method,
            coffeeBean: nil,
            coffeeWeight: coffeeWeight,
            waterWeight: waterWeight,
            grindSize: grindSize,
            waterTemperature: waterTemperature,
            totalTime: 25
        )
        
        brew.rating = rating
        brew.tastingNotes = ""
        brew.acidity = 3
        brew.sweetness = 3
        brew.bitterness = 3
        brew.body = 3
        
        modelContext.insert(brew)
        dismiss()
    }
}

struct ParameterRow: View {
    let label: String
    @Binding var value: Double
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            Text(label)
                .foregroundColor(.darkCoffeeBrown)
            Spacer()
            TextField("Wert", value: $value, format: .number)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .foregroundColor(.coffeeBrown)
                .fontWeight(.medium)
            Text(unit)
                .foregroundColor(.coffeeBrown)
                .font(.caption)
        }
    }
}
