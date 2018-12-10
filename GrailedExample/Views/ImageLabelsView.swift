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
    let style: Style
    let imageView = UIImageView()
    let headerLabel = UILabel()
    let subLabel = UILabel()
    
    // MARK: - Initalization
    init(style: Style = Style()) {
        self.style = style
        super.init(frame: .zero)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(headerText: String? = nil,
                   subText: String? = nil,
                   imageUrl: URL? = nil) {
        if let headerText = headerText {
           headerLabel.attributedText = NSAttributedString(string: headerText, attributes: style.headerLabel)
        }
        
        if let subText = subText {
            subLabel.attributedText = NSAttributedString(string: subText, attributes: style.subLabel)
        }
        
        if let imageUrl = imageUrl {
            imageView.kf.setImage(with: Constants.imageResizeUrl(imageUrl.absoluteString, width: 200))
        }
        
        headerLabel.isHidden = headerText == nil
        subLabel.isHidden = subText == nil
        imageView.isHidden = imageUrl == nil
    }

}

// MARK: - Constraints
extension ImageLabelsView {
    
    private func setupConstraints() {
        // Image View
        imageView.anchor(widthConstant: 80, heightConstant: 80)
        
        // Lables Stack View
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
        
        init(headerLabel: [NSAttributedString.Key: Any] =
            textAttributes(.black, UIFont.systemFont(ofSize: 14), .left),
             subLabel: [NSAttributedString.Key: Any] =
            textAttributes(.black, UIFont.systemFont(ofSize: 12), .left)) {
            self.headerLabel = headerLabel
            self.subLabel = subLabel
        }
    }
    
}
