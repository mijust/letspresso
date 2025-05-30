//
//  CoffeeTheme.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//


//
//  Colors.swift
//  letspresso
//
//  Created by Michael on 30.05.25.
//

import SwiftUI

extension Color {
    // Hauptfarben basierend auf dem Logo
    static let coffeeBrown = Color(red: 0.55, green: 0.27, blue: 0.07) // #8B4513
    static let lightCoffeeBrown = Color(red: 0.72, green: 0.45, blue: 0.20) // #B8733D
    static let darkCoffeeBrown = Color(red: 0.40, green: 0.20, blue: 0.05) // #66330D
    static let creamBackground = Color(red: 0.96, green: 0.96, blue: 0.86) // #F5F5DC
    static let warmWhite = Color(red: 0.98, green: 0.97, blue: 0.94) // #FAF7F0
    
    // Akzentfarben für verschiedene Zustände
    static let espressoGold = Color(red: 0.85, green: 0.65, blue: 0.13) // #D9A521
    static let steamWhite = Color(red: 0.95, green: 0.95, blue: 0.95) // #F2F2F2
    static let beanGreen = Color(red: 0.34, green: 0.55, blue: 0.34) // #578C57
    
    // Bewertungsfarben
    static let ratingGold = Color(red: 1.0, green: 0.84, blue: 0.0) // #FFD700
    static let positiveGreen = Color(red: 0.40, green: 0.70, blue: 0.40) // #66B366
    static let warningOrange = Color(red: 0.90, green: 0.60, blue: 0.20) // #E6992D
    static let negativeRed = Color(red: 0.80, green: 0.40, blue: 0.40) // #CC6666
}

// Theme für die App
struct CoffeeTheme {
    // Primäre Buttons
    static let primaryButton = Color.coffeeBrown
    static let primaryButtonText = Color.warmWhite
    
    // Sekundäre Buttons
    static let secondaryButton = Color.lightCoffeeBrown
    static let secondaryButtonText = Color.warmWhite
    
    // Hintergründe
    static let primaryBackground = Color.warmWhite
    static let cardBackground = Color.creamBackground
    
    // Text
    static let primaryText = Color.darkCoffeeBrown
    static let secondaryText = Color.coffeeBrown
    
    // Akzente
    static let accent = Color.espressoGold
    static let success = Color.positiveGreen
    static let warning = Color.warningOrange
    static let error = Color.negativeRed
}