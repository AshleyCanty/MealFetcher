//
//  UIView+extensions.swift
//  MealFetcher
//
//  Created by ashley canty on 11/5/23.
//

import UIKit

extension UIView {
    /// Custom method that adds multiple subviews
    func addSubviews(subviews: [UIView]) {
        subviews.forEach { view in
            self.addSubview(view)
        }
    }
}
