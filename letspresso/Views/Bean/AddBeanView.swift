//
//  AddBeanView.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//


//
//  AddBeanView.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//

import SwiftUI
import SwiftData

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
            ZStack {
                CoffeeTheme.primaryBackground.ignoresSafeArea() // Hintergrund
                
                Form {
                    Section {
                        BeanInputRow(
                            icon: "textformat",
                            label: "Name",
                            text: $name,
                            color: CoffeeTheme.primaryText // Primäre Textfarbe
                        )
                        
                        BeanInputRow(
                            icon: "building.2",
                            label: "Röster",
                            text: $roaster,
                            color: CoffeeTheme.secondaryText // Sekundäre Textfarbe
                        )
                        
                        BeanInputRow(
                            icon: "globe",
                            label: "Herkunft",
                            text: $origin,
                            color: Color.accentGreen // Akzentfarbe
                        )
                        
                        // Roast Level Picker
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(CoffeeTheme.warning) // Warnfarbe
                                .frame(width: 20)
                            Picker("Röstgrad", selection: $roastLevel) {
                                ForEach(RoastLevel.allCases, id: \.self) { level in
                                    Text(level.rawValue).tag(level)
                                }
                            }
                        }
                        
                        // Price Row
                        HStack {
                            Image(systemName: "eurosign.circle.fill")
                                .foregroundColor(CoffeeTheme.accent) // Akzentfarbe
                                .frame(width: 20)
                            Text("Preis pro kg")
                                .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
                            Spacer()
                            TextField("Preis", value: $pricePerKg, format: .currency(code: "EUR"))
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .foregroundColor(CoffeeTheme.secondaryText) // Sekundäre Textfarbe
                                .fontWeight(.medium)
                        }
                        
                    } header: {
                        Text("Basis Informationen")
                            .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
                    }
                    .listRowBackground(CoffeeTheme.cardBackground) // Kartenhintergrund
                    
                    Section {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(CoffeeTheme.accent) // Akzentfarbe
                                .frame(width: 20)
                            Text("Bewertung")
                                .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
                            Spacer()
                            Picker("Bewertung", selection: $rating) {
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
                            .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
                    }
                    .listRowBackground(CoffeeTheme.cardBackground) // Kartenhintergrund
                    
                    Section {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(CoffeeTheme.secondaryText) // Sekundäre Textfarbe
                                .frame(width: 20)
                            Toggle("Röstdatum bekannt", isOn: $hasRoastDate)
                                .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
                        }
                        
                        if hasRoastDate {
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                    .foregroundColor(CoffeeTheme.secondaryText) // Sekundäre Textfarbe
                                    .frame(width: 20)
                                DatePicker("Röstdatum", selection: $roastDate, displayedComponents: .date)
                                    .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
                            }
                        }
                    } header: {
                        Text("Röstdatum")
                            .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
                    }
                    .listRowBackground(CoffeeTheme.cardBackground) // Kartenhintergrund
                    
                    Section {
                        HStack(alignment: .top) {
                            Image(systemName: "note.text")
                                .foregroundColor(CoffeeTheme.secondaryText) // Sekundäre Textfarbe
                                .frame(width: 20)
                                .padding(.top, 8)
                            TextEditor(text: $notes)
                                .frame(minHeight: 100)
                                .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
                        }
                    } header: {
                        Text("Notizen")
                            .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
                    }
                    .listRowBackground(CoffeeTheme.cardBackground) // Kartenhintergrund
                }
                .scrollContentBackground(.hidden)
                .background(CoffeeTheme.primaryBackground) // Hintergrund
            }
            .navigationTitle("Neue Bohne")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(CoffeeTheme.primaryButton, for: .navigationBar) // Toolbar-Hintergrund
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                    .foregroundColor(CoffeeTheme.primaryButtonText) // Toolbar-Textfarbe
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
                    .foregroundColor(CoffeeTheme.primaryButtonText) // Toolbar-Textfarbe
                    .fontWeight(.semibold)
                }
            }
        }
        .accentColor(CoffeeTheme.primaryButton) // Akzentfarbe der Navigation
    }
}

struct BeanInputRow: View {
    let icon: String
    let label: String
    @Binding var text: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            TextField(label, text: $text)
                .foregroundColor(CoffeeTheme.primaryText) // Primäre Textfarbe
        }
    }
}
