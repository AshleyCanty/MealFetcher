//
//  UIColor+extension.swift
//  MealFetcher
//
//  Created by ashley canty on 11/5/23.
//

import UIKit

extension UIColor {
    
    /// Initializes a new UIColor instance from a hex string
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        let scanner = Scanner(string: hexString)
        
        var rgbValue: UInt64 = 0
        guard scanner.scanHexInt64(&rgbValue) else {
            self.init(white: 1.0, alpha: 1.0)
            return
        }
        
        var red, green, blue, alpha: UInt64

        red = (rgbValue >> 16)
        green = (rgbValue >> 8 & 0xFF)
        blue = (rgbValue & 0xFF)
        alpha = 255

        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
}
