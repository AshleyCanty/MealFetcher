//
//  Fraction+Enum.swift
//  MealFetcher
//
//  Created by ashley canty on 11/10/23.
//

import Foundation

/// Enum to represent Fractional values
enum Fraction: Double, CaseIterable {
    case Eighth = 0.125
    case Quarter = 0.25
    case Third = 0.333333333333333
    case Half = 0.5
    case TwoThirds = 0.666666666666667
    case ThreeQuarters = 0.75
    
    /// Returns string representation of the fraction
    static func localizedStringFromFraction(fraction: Fraction) -> String {
        switch fraction {
        case .Eighth:
            return NSLocalizedString("\u{215B}", comment: "Fraction - 1/8")
        case .Quarter:
            return NSLocalizedString("\u{00BC}", comment: "Fraction - 1/4")
        case .Third:
            return NSLocalizedString("\u{2153}", comment: "Fraction - 1/3")
        case .Half:
            return NSLocalizedString("\u{00BD}", comment: "Fraction - 1/2")
        case .TwoThirds:
            return NSLocalizedString("\u{2154}", comment: "Fraction - 2/3")
        case .ThreeQuarters:
            return NSLocalizedString("\u{00BE}", comment: "Fraction - 3/4")
        }
    }
}
