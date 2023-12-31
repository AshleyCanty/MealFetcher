//
//  AppFont.swift
//  MealFetcher
//
//  Created by ashley canty on 11/5/23.
//

import UIKit

/// A struct for the App's custom fonts. It holds methods that return UIFont objects.
public struct AppFont {
    static func regular(size: CGFloat) -> UIFont {
        return create(using: CustomFont.MontserratRegular, size: size, weight: .regular)
    }
    
    static func medium(size: CGFloat) -> UIFont {
        return create(using: CustomFont.MontserratMedium, size: size, weight: .medium)
    }
    
    static func semiBold(size: CGFloat) -> UIFont {
        return create(using: CustomFont.MontserratSemiBold, size: size, weight: .semibold)
    }
    /// Creates and returns a custom font. If the custom font cannot be found, it'll return a systemFont instead.
    fileprivate static func create(using font: CustomFont, size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return UIFont(customFont: font, size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
    }
}

/// Struct for custom fonts
public enum CustomFont: String {
    case MontserratRegular = "Montserrat-Regular"
    case MontserratMedium = "Montserrat-Medium"
    case MontserratSemiBold = "Montserrat-SemiBold"
}
