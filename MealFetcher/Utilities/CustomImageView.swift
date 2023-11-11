//
//  CustomImageView.swift
//  MealFetcher
//
//  Created by ashley canty on 11/6/23.
//

import UIKit

/// custom imageview class with spinner
class CustomImageView: UIImageView {
    struct Style {
        static let SpinnerSize: CGFloat = 46
    }
    
    let activityIndicator = UIActivityIndicatorView()
    
    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func showSpinner() {
        activityIndicator.startAnimating()
    }
    
    public func hideSpinner() {
        activityIndicator.stopAnimating()
    }
    
    private func configure() {
        addSubview(activityIndicator)
        
        activityIndicator.disableTranslatesAutoresizingMaskIntoContraints()
        activityIndicator.widthAnchor.fc_constrain(equalToConstant: Style.SpinnerSize)
        activityIndicator.heightAnchor.fc_constrain(equalToConstant: Style.SpinnerSize)
        activityIndicator.centerXAnchor.fc_constrain(equalTo: centerXAnchor)
        activityIndicator.centerYAnchor.fc_constrain(equalTo: centerYAnchor)
        
        activityIndicator.hidesWhenStopped = true
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
