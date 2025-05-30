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
    // Primary colors from the app icon
    static let primaryDarkBrown = Color(red: 0.35, green: 0.18, blue: 0.08) // A deep, rich brown from the bean in the icon
    static let backgroundCream = Color(red: 0.96, green: 0.95, blue: 0.92) // The light, warm background from the icon

    // Supporting browns for depth and hierarchy
    static let mediumBrown = Color(red: 0.50, green: 0.30, blue: 0.15) // A slightly lighter brown for contrast
    static let lightBrown = Color(red: 0.65, green: 0.45, blue: 0.25) // Even lighter, for subtle accents

    // Accent colors - chosen for modern vibrancy and contrast
    static let accentGold = Color(red: 0.85, green: 0.65, blue: 0.13) // Keeping a refined gold for highlights (similar to espressoGold)
    static let accentGreen = Color(red: 0.30, green: 0.60, blue: 0.30) // A fresh, muted green (similar to beanGreen but slightly more refined)
    static let accentBlue = Color(red: 0.25, green: 0.55, blue: 0.80) // A soft, modern blue for specific interactive elements

    // Status colors - refined versions
    static let successGreen = Color(red: 0.30, green: 0.70, blue: 0.30) // For positive feedback
    static let warningOrange = Color(red: 0.90, green: 0.60, blue: 0.20) // For warnings (kept similar as it's effective)
    static let errorRed = Color(red: 0.80, green: 0.30, blue: 0.30) // For errors
}

// Theme for the App
struct CoffeeTheme {
    // Primäre Buttons
    static let primaryButton = Color.primaryDarkBrown
    static let primaryButtonText = Color.backgroundCream
    
    // Sekundäre Buttons
    static let secondaryButton = Color.mediumBrown
    static let secondaryButtonText = Color.backgroundCream
    
    // Hintergründe
    static let primaryBackground = Color.backgroundCream
    static let cardBackground = Color.white.opacity(0.85) // A very subtle white with transparency for a sleek overlay effect
    
    // Text
    static let primaryText = Color.primaryDarkBrown
    static let secondaryText = Color.mediumBrown
    
    // Akzente
    static let accent = Color.accentGold
    static let success = Color.successGreen
    static let warning = Color.warningOrange
    static let error = Color.errorRed
}
