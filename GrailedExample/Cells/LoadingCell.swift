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
    let containerView = UIView()
    let loadingView = UIActivityIndicatorView(style: .gray)
    
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
        
        // Container View
        contentView.addSubview(containerView)
        containerView.fillSuperview()
        containerView.anchor(heightConstant: 90)
        
        // Loading View
        containerView.addSubview(loadingView)
        loadingView.anchorCenterSuperview()
        loadingView.startAnimating()
    }
    
}
