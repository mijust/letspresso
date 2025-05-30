//
//  Models.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//

import SwiftUI
import SwiftData
import Foundation

// Alle Enums und @Model Klassen hier

// MARK: - Enums

enum RoastLevel: String, CaseIterable, Codable {
    case light = "Light"
    case mediumLight = "Medium Light"
    case medium = "Medium"
    case mediumDark = "Medium Dark"
    case dark = "Dark"
}

enum BrewMethod: String, CaseIterable, Codable {
    case espresso = "Espresso"
    case v60 = "V60"
    case chemex = "Chemex"
    case kalitaWave = "Kalita Wave"
    case frenchPress = "French Press"
    case aeropress = "AeroPress"
}

enum GrindSize: String, CaseIterable, Codable {
    case extraFine = "Extra Fine"
    case fine = "Fine"
    case mediumFine = "Medium Fine"
    case medium = "Medium"
    case mediumCoarse = "Medium Coarse"
    case coarse = "Coarse"
}

// MARK: - Datenmodelle

@Model
class CoffeeBean {
    var id: UUID
    var name: String
    var roaster: String
    var origin: String
    var roastLevel: RoastLevel
    var pricePerKg: Double
    var purchaseDate: Date
    var roastDate: Date?
    var notes: String
    var rating: Int // 1-5
    
    @Relationship(deleteRule: .cascade) var brews: [Brew]
    
    init(name: String, roaster: String, origin: String, roastLevel: RoastLevel, pricePerKg: Double, purchaseDate: Date = Date(), roastDate: Date? = nil, notes: String = "", rating: Int = 3) {
        self.id = UUID()
        self.name = name
        self.roaster = roaster
        self.origin = origin
        self.roastLevel = roastLevel
        self.pricePerKg = pricePerKg
        self.purchaseDate = purchaseDate
        self.roastDate = roastDate
        self.notes = notes
        self.rating = rating
        self.brews = []
    }
}

@Model
class Brew {
    var id: UUID
    var date: Date
    var method: BrewMethod
    var coffeeBean: CoffeeBean?
    
    // Allgemeine Parameter
    var coffeeWeight: Double // in Gramm
    var waterWeight: Double // in Gramm
    var grindSize: GrindSize
    var waterTemperature: Double // in Celsius
    var totalTime: TimeInterval // in Sekunden
    
    // Espresso-spezifisch
    var yieldWeight: Double? // Ausgabe in Gramm
    var extractionTime: TimeInterval? // in Sekunden
    var pressure: Double? // in bar
    var preInfusionTime: TimeInterval? // in Sekunden
    
    // Pour Over spezifisch
    var bloomTime: TimeInterval? // in Sekunden
    var bloomWater: Double? // in Gramm
    var pourIntervals: [PourInterval]? // Gießintervalle
    
    // Bewertung
    var rating: Int // 1-5
    var tastingNotes: String
    var acidity: Int // 1-5
    var sweetness: Int // 1-5
    var bitterness: Int // 1-5
    var body: Int // 1-5
    
    init(method: BrewMethod, coffeeBean: CoffeeBean? = nil, coffeeWeight: Double, waterWeight: Double, grindSize: GrindSize, waterTemperature: Double, totalTime: TimeInterval) {
        self.id = UUID()
        self.date = Date()
        self.method = method
        self.coffeeBean = coffeeBean
        self.coffeeWeight = coffeeWeight
        self.waterWeight = waterWeight
        self.grindSize = grindSize
        self.waterTemperature = waterTemperature
        self.totalTime = totalTime
        self.rating = 3
        self.tastingNotes = ""
        self.acidity = 3
        self.sweetness = 3
        self.bitterness = 3
        self.body = 3
    }
    
    var ratio: Double {
        if method == .espresso, let yield = yieldWeight {
            return yield / coffeeWeight
        }
        return waterWeight / coffeeWeight
    }
}

@Model
class PourInterval {
    var time: TimeInterval
    var waterAmount: Double
    
    init(time: TimeInterval, waterAmount: Double) {
        self.time = time
        self.waterAmount = waterAmount
    }
}
