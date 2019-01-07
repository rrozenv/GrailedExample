//
//  GlobalFunctions.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/13/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

func textAttributes(_ color: UIColor = .black, _ font: UIFont = UIFont.systemFont(ofSize: 12), _ alignment: NSTextAlignment = .left) -> [NSAttributedString.Key: Any] {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = alignment
    
    return [
        .foregroundColor: color,
        .font: font,
        .paragraphStyle: paragraphStyle
    ]
}
