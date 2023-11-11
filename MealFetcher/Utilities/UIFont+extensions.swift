//
//  UIFont+extensions.swift
//  MealFetcher
//
//  Created by ashley canty on 11/5/23.
//

import UIKit

extension UIFont {
    /// A custom initializer that accepts a custom font and size
    convenience init?(customFont: CustomFont, size: CGFloat) {
        self.init(name: customFont.rawValue, size: size)
    }
}
