//
//  LoadingCell.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

final class LoadingCell: UITableViewCell {
    
    // MARK: - Properties
    private let containerView = UIView()
    private let loadingView = UIActivityIndicatorView(style: .gray)
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func configure() {
        loadingView.startAnimating()
    }
    
    private func commonInit() {
        contentView.backgroundColor = UIColor.white
        
        // Container View
        contentView.addSubview(containerView)
        containerView.fillSuperview()

        // Loading View
        containerView.addSubview(loadingView)
        loadingView.anchorCenterXToSuperview()
        loadingView.anchor(contentView.topAnchor, bottom: contentView.bottomAnchor, topConstant: 15, bottomConstant: 15)
    }
    
}
