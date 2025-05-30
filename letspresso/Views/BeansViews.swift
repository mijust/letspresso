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

// MARK: - Bean Detail View

struct BeanDetailView: View {
    let bean: CoffeeBean
    @Query private var brews: [Brew]
    
    var beanBrews: [Brew] {
        brews.filter { $0.coffeeBean?.id == bean.id }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(bean.roaster)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(bean.origin)
                        .font(.title2)
                    HStack {
                        ForEach(0..<5) { index in
                            Image(systemName: index < bean.rating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Details
                GroupBox("Details") {
                    VStack(spacing: 12) {
                        DetailRow(label: "Röstgrad", value: bean.roastLevel.rawValue)
                        DetailRow(label: "Preis", value: String(format: "%.2f €/kg", bean.pricePerKg))
                        if let roastDate = bean.roastDate {
                            DetailRow(label: "Röstdatum", value: roastDate.formatted(date: .abbreviated, time: .omitted))
                        }
                    }
                }
                .padding(.horizontal)
                
                // Notes
                if !bean.notes.isEmpty {
                    GroupBox("Notizen") {
                        Text(bean.notes)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                }
                
                // Related Brews
                if !beanBrews.isEmpty {
                    GroupBox("Brühungen (\(beanBrews.count))") {
                        ForEach(beanBrews) { brew in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(brew.method.rawValue)
                                        .font(.headline)
                                    Spacer()
                                    Text(brew.date, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                HStack {
                                    Text("Bewertung: \(brew.rating)/5")
                                        .font(.caption)
                                    Spacer()
                                    if brew.method == .espresso {
                                        Text("\(brew.coffeeWeight, specifier: "%.1f")g → \(brew.yieldWeight ?? 0, specifier: "%.1f")g")
                                            .font(.caption)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(bean.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
    }
}

// MARK: - Add Bean View

struct AddBeanView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var roaster = ""
    @State private var origin = ""
    @State private var roastLevel: RoastLevel = .medium
    @State private var pricePerKg = 30.0
    @State private var notes = ""
    @State private var rating = 3
    @State private var roastDate = Date()
    @State private var hasRoastDate = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basis Informationen") {
                    TextField("Name", text: $name)
                    TextField("Röster", text: $roaster)
                    TextField("Herkunft", text: $origin)
                    
                    Picker("Röstgrad", selection: $roastLevel) {
                        ForEach(RoastLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    
                    HStack {
                        Text("Preis pro kg")
                        Spacer()
                        TextField("Preis", value: $pricePerKg, format: .currency(code: "EUR"))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section("Bewertung") {
                    Picker("Bewertung", selection: $rating) {
                        ForEach(1...5, id: \.self) { value in
                            HStack {
                                Text("\(value)")
                                Image(systemName: "star.fill")
                            }.tag(value)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Röstdatum") {
                    Toggle("Röstdatum bekannt", isOn: $hasRoastDate)
                    if hasRoastDate {
                        DatePicker("Röstdatum", selection: $roastDate, displayedComponents: .date)
                    }
                }
                
                Section("Notizen") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Neue Bohne")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Speichern") {
                        let bean = CoffeeBean(
                            name: name,
                            roaster: roaster,
                            origin: origin,
                            roastLevel: roastLevel,
                            pricePerKg: pricePerKg,
                            roastDate: hasRoastDate ? roastDate : nil,
                            notes: notes,
                            rating: rating
                        )
                        modelContext.insert(bean)
                        dismiss()
                    }
                    .disabled(name.isEmpty || roaster.isEmpty)
                }
            }
        }
    }
}
