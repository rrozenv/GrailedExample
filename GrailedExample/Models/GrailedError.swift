//
//  GrailedError.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation

// MARK: - GrailedError
struct GrailedError: Codable, Error {
    let code: Int
    let message: String
}
