//
//  Theme.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/19/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

enum Theme: Int {
    
    case theme1, theme2
    
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .theme1
    }
    
    func apply() {
        //1
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        
        //2
        UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().tintColor = primaryBackgroundColor
        UINavigationBar.appearance().backgroundColor = primaryBackgroundColor
        UINavigationBar.appearance().titleTextAttributes = textAttributes(.blue)
        UINavigationBar.appearance().largeTitleTextAttributes = textAttributes(.blue)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        NotificationCenter.default.post(name: .themeChanged, object: nil)
    }

    var primaryBackgroundColor: UIColor {
        switch self {
        case .theme1:
            return Palette.aqua.color
        case .theme2:
            return Palette.purple.color
        }
    }
    
    var primaryTextAttributes: [NSAttributedString.Key: Any] {
        switch self {
        case .theme1:
            return textAttributes(.red, UIFont.systemFont(ofSize: 15), .left)
        case .theme2:
            return textAttributes(.green, UIFont.systemFont(ofSize: 15), .left)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .theme1:
            return .default
        case .theme2:
            return .black
        }
    }
    
}

enum Palette {
    case appBackground, aqua, lightGrey, faintGrey, lightBlue, faintBlue, darkGrey, darkNavy, purple, charcoal, tabGray
    
    var color: UIColor {
        switch self {
        case .appBackground: return UIColor(hex: 0xFCFEFF)
        case .tabGray: return UIColor(hex: 0xC7C7C7)
        case .lightGrey: return UIColor(hex: 0xF2F2F2)
        case .faintGrey: return UIColor(hex: 0xFAFAFA)
        case .darkGrey: return UIColor(hex: 0x717171)
        case .darkNavy: return UIColor(hex: 0x2D3C44)
        case .lightBlue: return UIColor(hex: 0x8FA8B5)
        case .faintBlue: return UIColor(hex: 0xF2F6F8)
        case .purple: return UIColor(hex: 0x68669F)
        case .aqua: return UIColor(hex: 0x9ADBCA)
        case .charcoal: return UIColor(hex: 0x5E5E5E)
        }
    }
}

extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    class func forGradient(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
}
