//
//  Cache.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift

public class Storage {
    
    private init() { }
    
    public enum Directory {
        case documents
        case caches
    }
    
    // MARK: - Public Interface
    /// Used to store encodable objects
    public static func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String? = nil) -> Completable {
        return Completable.create { (observer) -> Disposable in
            let url = getURL(for: directory).appendingPathComponent("\(T.self).type.\(fileName ?? "")", isDirectory: false)
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(object)
                if FileManager.default.fileExists(atPath: url.path) {
                    try FileManager.default.removeItem(at: url)
                }
                FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
                debugPrint("Successfully saved \(T.self) to storage")
                observer(.completed)
            } catch {
                debugPrint("Failed to save \(T.self) to storage")
            }
            
            return Disposables.create()
        }
    }
    
    /// Used to retrieve decodable objects
    public static func retrieve<T: Decodable>(_ fileName: String? = nil,
                                       from directory: Directory = .documents,
                                       as type: T.Type) -> Maybe<T> {
        return Maybe<T>.create { (observer) -> Disposable in
            let url = getURL(for: directory)
                .appendingPathComponent("\(T.self).type.\(fileName ?? "")", isDirectory: false)

            guard FileManager.default.fileExists(atPath: url.path) else {
                debugPrint("File does not exist for \(T.self) storage")
                observer(MaybeEvent.completed)
                return Disposables.create()
            }
            
            guard let data = FileManager.default.contents(atPath: url.path) else {
                debugPrint("Failed to fetch \(T.self) from storage")
                observer(MaybeEvent.completed)
                return Disposables.create()
            }
            
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(type, from: data)
                debugPrint("Successfully fetched \(T.self) from storage")
                observer(MaybeEvent.success(model))
            } catch {
                debugPrint("Failed to fetch \(T.self) from storage")
            }
            
            observer(MaybeEvent.completed)
            
            return Disposables.create()
        }
    }
    
    /// Remove all files at specified directory
    public static func clear(_ directory: Directory) {
        let url = getURL(for: directory)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Remove specified file from specified directory
    public static func remove(_ fileName: String, from directory: Directory) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    /// Returns BOOL indicating whether file exists at specified directory with specified file name
    public static func fileExists(_ fileName: String, in directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
    
}

// MARK: - Private Methods
extension Storage {
    
    /// Returns URL constructed from specified directory
    private static func getURL(for directory: Directory) -> URL {
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }
        
        if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
    }
    
}
