//
//  ArticleCell.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ImageLabelsCell
final class ImageLabelsCell: UITableViewCell {
    
    // MARK: - Properties
    let imageLabelsView = ImageLabelsView()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(imageLabelsView)
        imageLabelsView.fillSuperview()
    }
    
}

// MARK: - ImageLabelsCellConfigurator
struct ImageLabelsCellConfigurator<Model> {
    let headerKeyPath: KeyPath<Model, String>
    let subtitleKeyPath: KeyPath<Model, String>
    let imageUrlKeyPath: KeyPath<Model, URL?>?
    
    func configure(_ cell: ImageLabelsCell, for model: Model) {
        let header = model[keyPath: headerKeyPath]
        let subtitle = model[keyPath: subtitleKeyPath]
        var imageUrl: URL?
        if let imageUrlKeyPath = imageUrlKeyPath { imageUrl = model[keyPath: imageUrlKeyPath] }
        
        /// View Configuration
        cell.imageLabelsView.headerText = header
        cell.imageLabelsView.subTitleText = subtitle
        cell.imageLabelsView.imageView.isHidden = imageUrl == nil
        cell.imageLabelsView.headerLabel.isHidden = header == ""
        cell.imageLabelsView.subLabel.isHidden = subtitle == ""
        
        guard imageUrl != nil else { return }
        cell.imageLabelsView.imageView.kf.setImage(with: Constants.imageResizeUrl(imageUrl!.absoluteString, width: 200))
    }
}

