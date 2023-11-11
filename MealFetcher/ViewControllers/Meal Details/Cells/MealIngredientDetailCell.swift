//
//  MealIngredientDetailCell.swift
//  MealFetcher
//
//  Created by ashley canty on 11/6/23.
//

import UIKit

/// MealIngredientDetailCell
class MealIngredientDetailCell: UITableViewCell {
    /// reuseID
    static let reuseId = "MealIngredientDetailCell"
    /// style struct
    struct Style {
        static let LeadingMargin: CGFloat = AppContraintConstants.PaddedLeadingTrailingMargin
        static let TitleFont: UIFont = AppFont.regular(size: 13)
        static let TextColor: UIColor = AppColors.TextColorPrimary
    }
    
    /// field title label
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.TitleFont
        label.textColor = Style.TextColor
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// configure views
    private func configure() {
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = AppColors.BackgroundMain
        titleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        titleLabel.centerYAnchor.fc_constrain(equalTo: contentView.centerYAnchor)
        titleLabel.leadingAnchor.fc_constrain(equalTo: contentView.leadingAnchor, constant: Style.LeadingMargin)
    }
}
