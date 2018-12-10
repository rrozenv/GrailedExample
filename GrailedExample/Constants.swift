//
//  Constants.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation

struct Constants {
    static let baseUrl = "https://www.grailed.com"
    static func imageResizeUrl(_ imageUrl: String, width: Int) -> URL? {
        return URL(string: "https://cdn.fs.grailed.com/AJdAgnqCST4iPtnUxiGtTz/rotate=deg:exif/rotate=deg:0/resize=width:\(width),fit:crop/output=format:jpg,compress:true,quality:95/\(imageUrl)")
    }
}
