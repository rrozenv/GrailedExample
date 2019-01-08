//
//  Environment.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 1/7/19.
//  Copyright © 2019 Cluk Labs. All rights reserved.
//

import Foundation

public enum Environment {
    enum Keys {
        enum Plist {
            static let rootURL = "ROOT_URL"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let rootURL: URL = {
        guard let rootURLstring = Environment.infoDictionary[Keys.Plist.rootURL] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        guard let url = URL(string: rootURLstring) else {
            fatalError("Root URL is invalid")
        }
        return url
    }()
}

