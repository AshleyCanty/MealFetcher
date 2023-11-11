//
//  CategoryMealCell.swift
//  MealFetcher
//
//  Created by ashley canty on 11/5/23.
//

import UIKit
import Combine

/// CategoryMealCell
class CategoryMealCell: UITableViewCell {
    /// reuseID
    static let reuseId = "CategoryMealCell"
    /// style struct
    struct Style {
        static let LeadingMargin: CGFloat = AppContraintConstants.PaddedLeadingTrailingMargin
        static let ImageSize: CGFloat = 100
        static let ImageCornerRadius: CGFloat = 8
        static let TitleLeadingMargin: CGFloat = AppContraintConstants.LeadingTrailingMargin
        static let TitleFont: UIFont = AppFont.semiBold(size: 13)
        static let TextColor: UIColor = AppColors.TextColorPrimary
    }
    
    /// title label
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.TitleFont
        label.textColor = Style.TextColor
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    ///  thumbnail
    public let thumbnail: CustomImageView = {
       let imgView = CustomImageView()
        imgView.layer.cornerRadius = Style.ImageCornerRadius
        imgView.backgroundColor = AppColors.BackgroundSecondary
        return imgView
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
        accessoryType = .disclosureIndicator
        contentView.addSubviews(subviews: [thumbnail, titleLabel])
        
        let selectedView = UIView()
        selectedView.backgroundColor = AppColors.BackgroundSecondary
        
        let normalView = UIView()
        normalView.backgroundColor = AppColors.BackgroundMain
        
        selectedBackgroundView = selectedView
        backgroundView = normalView
        
        thumbnail.disableTranslatesAutoresizingMaskIntoContraints()
        thumbnail.centerYAnchor.fc_constrain(equalTo: contentView.centerYAnchor)
        thumbnail.leadingAnchor.fc_constrain(equalTo: contentView.leadingAnchor, constant: Style.LeadingMargin)
        thumbnail.heightAnchor.fc_constrain(equalToConstant: Style.ImageSize)
        thumbnail.widthAnchor.fc_constrain(equalToConstant: Style.ImageSize)
        
        titleLabel.disableTranslatesAutoresizingMaskIntoContraints()
        titleLabel.topAnchor.fc_constrain(equalTo: thumbnail.topAnchor, constant: Style.LeadingMargin)
        titleLabel.leadingAnchor.fc_constrain(equalTo: thumbnail.trailingAnchor, constant: Style.TitleLeadingMargin)
        titleLabel.trailingAnchor.fc_constrain(equalTo: contentView.trailingAnchor, constant: -Style.TitleLeadingMargin)
    }
}


