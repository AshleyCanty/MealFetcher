//
//  MealInstructionDetailCell.swift
//  MealFetcher
//
//  Created by ashley canty on 11/6/23.
//

import UIKit
import Combine

/// MealInstructionDetailCell
class MealInstructionDetailCell: UITableViewCell {
    /// reuseID
    static let reuseId = "MealInstructionDetailCell"
    /// Style struct
    struct Style {
        static let BackgroundColor: UIColor = AppColors.BackgroundMain
        static let LeadingMargin: CGFloat = AppContraintConstants.PaddedLeadingTrailingMargin
        static let ImageSize: CGFloat = 100
        static let ImageCornerRadius: CGFloat = 8
        static let TextColor: UIColor = AppColors.TextColorPrimary
        static let TextViewFont: UIFont = AppFont.regular(size: 14)
    }
    
    /// summary textView
    public lazy var textView: UITextView! = {
        let textview = UITextView()
        textview.font = Style.TextViewFont
        textview.textColor = Style.TextColor
        textview.isEditable = false
        textview.isScrollEnabled = false
        textview.backgroundColor = Style.BackgroundColor
        textview.textContainerInset = .zero
        textview.textContainer.lineFragmentPadding = 0
        return textview
    }()
    /// text view height
    var textViewHeight: CGFloat = 0
    /// stores subscription
    var cancellable: AnyCancellable?
    /// Publisher for when text view height changes
    let updateTextViewCellHeight = PassthroughSubject<CGFloat, Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /// Publish value of text view height if it increased
        let contentSize = textView?.sizeThatFits(textView?.bounds.size ?? .zero) ?? .zero
        if contentSize.height > textViewHeight {
            textViewHeight = contentSize.height
            updateTextViewCellHeight.send(contentSize.height)
        }
    }
    
    /// configure views
    private func configure() {
        contentView.addSubview(textView)
        contentView.backgroundColor = AppColors.BackgroundMain
        textView.disableTranslatesAutoresizingMaskIntoContraints()
        textView.topAnchor.fc_constrain(equalTo: contentView.topAnchor)
        textView.bottomAnchor.fc_constrain(equalTo: contentView.bottomAnchor)
        textView.leadingAnchor.fc_constrain(equalTo: contentView.leadingAnchor, constant: Style.LeadingMargin)
        textView.trailingAnchor.fc_constrain(equalTo: contentView.trailingAnchor, constant: -Style.LeadingMargin)
    }
}
 
