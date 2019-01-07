//
//  ArticleCellView.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

final class ImageLabelsView: UIView {
    
    // MARK: - Properties
    var style: Style
    let imageView = UIImageView()
    let headerLabel = UILabel()
    let subLabel = UILabel()
    
    // MARK: - Initalization
    init(style: Style = ImageLabelsView.Style.defaultStyle) {
        self.style = style
        super.init(frame: .zero)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    // MARK: - Configuration
    var headerText: String = "" {
        didSet {
            headerLabel.attributedText = NSAttributedString(string: headerText,
                                                            attributes: style.headerLabel)
        }
    }
    
    var subTitleText: String = "" {
        didSet {
            subLabel.attributedText = NSAttributedString(string: subTitleText,
                                                         attributes: style.subLabel)
        }
    }
    
}

// MARK: - Constraints
extension ImageLabelsView {
    
    private func setupConstraints() {
        // Image View
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        let imageHeightAnchor = imageView.heightAnchor.constraint(equalToConstant: 80)
        imageHeightAnchor.priority = UILayoutPriority(999)
        imageHeightAnchor.isActive = true
        
        // Lables Stack View
        headerLabel.numberOfLines = 0
        subLabel.numberOfLines = 0
        let labelsSv = UIStackView(arrangedSubviews: [headerLabel, subLabel])
        labelsSv.axis = .vertical
        labelsSv.spacing = 10
        
        // Container Stack View
        let containerSv = UIStackView(arrangedSubviews: [imageView, labelsSv])
        containerSv.axis = .horizontal
        containerSv.spacing = 10
        containerSv.distribution = .fillProportionally
        containerSv.alignment = .center
        
        addSubview(containerSv)
        containerSv.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 15, leftConstant: 15, bottomConstant: 15, rightConstant: 15)
    }
    
}

// MARK: - Style
extension ImageLabelsView {
    
    class Style {
        var headerLabel: [NSAttributedString.Key: Any]
        var subLabel: [NSAttributedString.Key: Any]
        
        init(headerLabel: [NSAttributedString.Key: Any],
             subLabel: [NSAttributedString.Key: Any]) {
            self.headerLabel = headerLabel
            self.subLabel = subLabel
        }
        
        static var defaultStyle: Style {
            return Style(headerLabel: Theme.current.primaryTextAttributes,
                         subLabel: Theme.current.primaryTextAttributes)
        }
    }
    
}
