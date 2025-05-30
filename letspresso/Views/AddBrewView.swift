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
            Form {
                Section("Parameter") {
                    HStack {
                        Text("Kaffee (g)")
                        Spacer()
                        TextField("Gramm", value: $coffeeWeight, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Wasser (g)")
                        Spacer()
                        TextField("Gramm", value: $waterWeight, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    Picker("Mahlgrad", selection: $grindSize) {
                        ForEach(GrindSize.allCases, id: \.self) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }
                    
                    HStack {
                        Text("Temperatur (°C)")
                        Spacer()
                        TextField("Grad", value: $waterTemperature, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section("Bewertung") {
                    Picker("Gesamt", selection: $rating) {
                        ForEach(1...5, id: \.self) { value in
                            Text("\(value) ⭐").tag(value)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Neue \(method.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Speichern") {
                        saveBasicBrew()
                    }
                }
            }
        }
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
