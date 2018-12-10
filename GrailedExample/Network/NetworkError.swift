//
//  NetworkError.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation

public protocol ErrorRepresentable {
    var error: Error? { get }
    var header: String { get }
    var message: String { get }
    var shouldDisplay: Bool { get }
}

public enum NetworkError: Error {
    case serverFailed
    case serverError(Error)
    case statusCodeError(Int)
    case decodingError(String)
    case customError(Error)
}

extension NetworkError: ErrorRepresentable {
    public var header: String { return "Network Error" }
    public var shouldDisplay: Bool { return true }
    public var message: String {
        switch self {
        case .customError(let error):
            return error.localizedDescription
        case .serverError:
            return "Server Error"
        case .decodingError(let objectType):
            return "Failed to decode object of type: \(objectType) from network."
        case .serverFailed:
            return "Server failed to respond."
        case .statusCodeError(let statusCode):
            return "Response failed with status code: \(statusCode)"
        }
    }
    
    public var error: Error? {
        switch self {
        case .customError(let error): return error
        case .serverError(let error): return error
        default: return nil
        }
    }
}
