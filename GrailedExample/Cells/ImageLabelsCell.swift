//
//  ArticleCell.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

final class ImageLabelsCell: UITableViewCell {
    
    // MARK: - Properties
    private let imageLabelsView = ImageLabelsView()

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

    // MARK: - Configurations
    func configure(with article: ArticleViewModel) {
        imageLabelsView.style.subLabel = textAttributes(.blue, UIFont.systemFont(ofSize: 12), .left)
        imageLabelsView.configure(headerText: article.title, subText: article.author)
    }
    
    func configure(with savedSearch: SavedSearchViewModel) {
        imageLabelsView.style.headerLabel = textAttributes(.black, UIFont.systemFont(ofSize: 15), .left)
        imageLabelsView.imageView.kf.indicatorType = .activity
        imageLabelsView.imageView.contentMode = .scaleAspectFill
        imageLabelsView.imageView.clipsToBounds = true
        imageLabelsView.configure(headerText: savedSearch.name, imageUrl: savedSearch.imageUrl)
    }

}
