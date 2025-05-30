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
                Color.warmWhite.ignoresSafeArea()
                
                Form {
                    Section {
                        BeanInputRow(
                            icon: "textformat",
                            label: "Name",
                            text: $name,
                            color: .darkCoffeeBrown
                        )
                        
                        BeanInputRow(
                            icon: "building.2",
                            label: "Röster",
                            text: $roaster,
                            color: .coffeeBrown
                        )
                        
                        BeanInputRow(
                            icon: "globe",
                            label: "Herkunft",
                            text: $origin,
                            color: .beanGreen
                        )
                        
                        // Roast Level Picker
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.warningOrange)
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
                                .foregroundColor(.espressoGold)
                                .frame(width: 20)
                            Text("Preis pro kg")
                                .foregroundColor(.darkCoffeeBrown)
                            Spacer()
                            TextField("Preis", value: $pricePerKg, format: .currency(code: "EUR"))
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .foregroundColor(.coffeeBrown)
                                .fontWeight(.medium)
                        }
                        
                    } header: {
                        Text("Basis Informationen")
                            .foregroundColor(.coffeeBrown)
                    }
                    .listRowBackground(Color.creamBackground)
                    
                    Section {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.ratingGold)
                                .frame(width: 20)
                            Text("Bewertung")
                                .foregroundColor(.darkCoffeeBrown)
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
                            .foregroundColor(.coffeeBrown)
                    }
                    .listRowBackground(Color.creamBackground)
                    
                    Section {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.lightCoffeeBrown)
                                .frame(width: 20)
                            Toggle("Röstdatum bekannt", isOn: $hasRoastDate)
                                .foregroundColor(.darkCoffeeBrown)
                        }
                        
                        if hasRoastDate {
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                    .foregroundColor(.lightCoffeeBrown)
                                    .frame(width: 20)
                                DatePicker("Röstdatum", selection: $roastDate, displayedComponents: .date)
                                    .foregroundColor(.darkCoffeeBrown)
                            }
                        }
                    } header: {
                        Text("Röstdatum")
                            .foregroundColor(.coffeeBrown)
                    }
                    .listRowBackground(Color.creamBackground)
                    
                    Section {
                        HStack(alignment: .top) {
                            Image(systemName: "note.text")
                                .foregroundColor(.coffeeBrown)
                                .frame(width: 20)
                                .padding(.top, 8)
                            TextEditor(text: $notes)
                                .frame(minHeight: 100)
                                .foregroundColor(.darkCoffeeBrown)
                        }
                    } header: {
                        Text("Notizen")
                            .foregroundColor(.coffeeBrown)
                    }
                    .listRowBackground(Color.creamBackground)
                }
                .scrollContentBackground(.hidden)
                .background(Color.warmWhite)
            }
            .navigationTitle("Neue Bohne")
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
                    .foregroundColor(.warmWhite)
                    .fontWeight(.semibold)
                }
            }
        }
        .accentColor(.coffeeBrown)
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
                .foregroundColor(.darkCoffeeBrown)
        }
    }
}
