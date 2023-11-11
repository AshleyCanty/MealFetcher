//
//  AutoLayout+extensions.swift
//  MealFetcher
//
//  Created by ashley canty on 11/5/23.
//

import UIKit

// Note** The "fc_" prefix just acts as a reference for the app name "fetch challenge", to make clear that it's a custom method :D

/// NSLayoutAnchor extension holding custom methods
extension NSLayoutAnchor {
    /// Method that automatically activates a constraint and adds the provided constant
    @objc func fc_constrain(equalTo anchor: NSLayoutAnchor, constant: CGFloat) {
        self.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    /// Method that automatically activates a constraint
    @objc func fc_constrain(equalTo anchor: NSLayoutAnchor) {
        self.constraint(equalTo: anchor).isActive = true
    }
}

extension NSLayoutDimension {
    /// Method that automatically activates a constraint
    @objc func fc_constrain(equalToConstant constant: CGFloat) {
        self.constraint(equalToConstant: constant).isActive = true
    }
}

extension UIView {
    /// Custom method that sets the "TranslateAutoresizingMaskIntoContraints" property to false
    func disableTranslatesAutoresizingMaskIntoContraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
