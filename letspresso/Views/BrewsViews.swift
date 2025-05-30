//
//  BrewsViews.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//

import SwiftUI
import SwiftData

// MARK: - Brews List View
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

// MARK: - Brew Row View
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
                    Text(String(format: "%.1fg → %.1fg", brew.coffeeWeight, brew.yieldWeight ?? 0))
                        .font(.caption)
                } else {
                    Text(String(format: "%.1fg : %.0fg", brew.coffeeWeight, brew.waterWeight))
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

// MARK: - Brew Detail View
struct BrewDetailView: View {
    let brew: Brew
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Coffee Bean Info
                if let bean = brew.coffeeBean {
                    GroupBox("Bohne") {
                        VStack(alignment: .leading) {
                            Text(bean.name)
                                .font(.headline)
                            Text("\(bean.roaster) - \(bean.origin)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                // Brew Parameters
                GroupBox("Parameter") {
                    VStack(spacing: 12) {
                        DetailRow(label: "Methode", value: brew.method.rawValue)
                        DetailRow(label: "Kaffee", value: String(format: "%.1fg", brew.coffeeWeight))
                        
                        if brew.method == .espresso {
                            DetailRow(label: "Yield", value: String(format: "%.1fg", brew.yieldWeight ?? 0))
                            DetailRow(label: "Ratio", value: String(format: "1:%.1f", brew.ratio))
                            if let time = brew.extractionTime {
                                DetailRow(label: "Zeit", value: "\(Int(time))s")
                            }
                        } else {
                            DetailRow(label: "Wasser", value: String(format: "%.0fg", brew.waterWeight))
                            DetailRow(label: "Ratio", value: String(format: "1:%.1f", brew.ratio))
                        }
                        
                        DetailRow(label: "Temperatur", value: String(format: "%.0f°C", brew.waterTemperature))
                        DetailRow(label: "Mahlgrad", value: brew.grindSize.rawValue)
                    }
                }
                
                // Taste Profile
                GroupBox("Geschmacksprofil") {
                    VStack(spacing: 12) {
                        RatingRow(label: "Gesamt", value: brew.rating)
                        RatingRow(label: "Säure", value: brew.acidity)
                        RatingRow(label: "Süße", value: brew.sweetness)
                        RatingRow(label: "Bitterkeit", value: brew.bitterness)
                        RatingRow(label: "Körper", value: brew.body)
                    }
                }
                
                // Tasting Notes
                if !brew.tastingNotes.isEmpty {
                    GroupBox("Verkostungsnotizen") {
                        Text(brew.tastingNotes)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(brew.date.formatted(date: .abbreviated, time: .shortened))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Rating Row View
struct RatingRow: View {
    let label: String
    let value: Int
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Image(systemName: index < value ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}

// MARK: - Add Brew View
struct AddBrewView: View {
    let method: BrewMethod
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var beans: [CoffeeBean]
    
    // Common parameters
    @State private var selectedBean: CoffeeBean?
    @State private var coffeeWeight = 18.0
    @State private var waterWeight = 250.0
    @State private var grindSize: GrindSize = .fine
    @State private var waterTemperature = 93.0
    @State private var totalTime: TimeInterval = 25
    
    // Espresso specific
    @State private var yieldWeight = 36.0
    @State private var extractionTime: TimeInterval = 25
    @State private var pressure = 9.0
    @State private var preInfusionTime: TimeInterval = 5
    
    // Pour Over specific
    @State private var bloomTime: TimeInterval = 30
    @State private var bloomWater = 50.0
    
    // Rating
    @State private var rating = 3
    @State private var tastingNotes = ""
    @State private var acidity = 3
    @State private var sweetness = 3
    @State private var bitterness = 3
    @State private var body = 3
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Bohne") {
                    Picker("Kaffeebohne", selection: $selectedBean) {
                        Text("Keine ausgewählt").tag(nil as CoffeeBean?)
                        ForEach(beans) { bean in
                            Text("\(bean.name) - \(bean.roaster)").tag(bean as CoffeeBean?)
                        }
                    }
                }
                
                Section("Parameter") {
                    HStack {
                        Text("Kaffee (g)")
                        Spacer()
                        TextField("Gramm", value: $coffeeWeight, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    if method == .espresso {
                        HStack {
                            Text("Yield (g)")
                            Spacer()
                            TextField("Gramm", value: $yieldWeight, format: .number)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        
                        HStack {
                            Text("Zeit (s)")
                            Spacer()
                            TextField("Sekunden", value: $extractionTime, format: .number)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        }
                    } else {
                        HStack {
                            Text("Wasser (g)")
                            Spacer()
                            TextField("Gramm", value: $waterWeight, format: .number)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        
                        if method == .v60 || method == .chemex || method == .kalitaWave {
                            HStack {
                                Text("Bloom Zeit (s)")
                                Spacer()
                                TextField("Sekunden", value: $bloomTime, format: .number)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numberPad)
                            }
                            
                            HStack {
                                Text("Bloom Wasser (g)")
                                Spacer()
                                TextField("Gramm", value: $bloomWater, format: .number)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                            }
                        }
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
                    
                    VStack(alignment: .leading) {
                        Text("Geschmacksprofil")
                            .font(.headline)
                            .padding(.top, 4)
                        
                        HStack {
                            Text("Säure")
                            Spacer()
                            Picker("", selection: $acidity) {
                                ForEach(1...5, id: \.self) { Text("\($0)").tag($0) }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 200)
                        }
                        
                        HStack {
                            Text("Süße")
                            Spacer()
                            Picker("", selection: $sweetness) {
                                ForEach(1...5, id: \.self) { Text("\($0)").tag($0) }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 200)
                        }
                        
                        HStack {
                            Text("Bitterkeit")
                            Spacer()
                            Picker("", selection: $bitterness) {
                                ForEach(1...5, id: \.self) { Text("\($0)").tag($0) }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 200)
                        }
                        
                        HStack {
                            Text("Körper")
                            Spacer()
                            Picker("", selection: $body) {
                                ForEach(1...5, id: \.self) { Text("\($0)").tag($0) }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 200)
                        }
                    }
                }
                
                Section("Notizen") {
                    TextEditor(text: $tastingNotes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Neue \(method.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Speichern") {
                        let brew = Brew(
                            method: method,
                            coffeeBean: selectedBean,
                            coffeeWeight: coffeeWeight,
                            waterWeight: waterWeight,
                            grindSize: grindSize,
                            waterTemperature: waterTemperature,
                            totalTime: totalTime
                        )
                        
                        // Set method-specific values
                        if method == .espresso {
                            brew.yieldWeight = yieldWeight
                            brew.extractionTime = extractionTime
                            brew.pressure = pressure
                            brew.preInfusionTime = preInfusionTime
                        } else if method == .v60 || method == .chemex || method == .kalitaWave {
                            brew.bloomTime = bloomTime
                            brew.bloomWater = bloomWater
                        }
                        
                        // Set ratings
                        brew.rating = rating
                        brew.tastingNotes = tastingNotes
                        brew.acidity = acidity
                        brew.sweetness = sweetness
                        brew.bitterness = bitterness
                        brew.body = body
                        
                        modelContext.insert(brew)
                        dismiss()
                    }
                }
            }
        }
    }
}
