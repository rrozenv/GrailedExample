//
//  Network.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Alamofire
import RxAlamofire
import RxSwift

final class Network<T: Codable> {

    private let endPoint: String
    private let scheduler: ConcurrentDispatchQueueScheduler

    init(_ endPoint: String) {
        self.endPoint = endPoint
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: .userInitiated)
    }

    func getItems(_ path: String,
                  parameters: [String: Any]? = nil,
                  encoding: ParameterEncoding = JSONEncoding.default,
                  headers: [String: String] = [:]) -> Observable<[T]> {
        let absolutePath = "\(endPoint)/\(path)"
        return RxAlamofire
            .requestData(.get, absolutePath,
                         parameters: parameters,
                         encoding: encoding,
                         headers: headers)
            .observeOn(scheduler)
            .mapArray(type: T.self, errorType: GrailedError.self)
    }

    func getItem(_ path: String,
                 parameters: [String: Any]? = nil,
                 encoding: ParameterEncoding = JSONEncoding.default,
                 headers: [String: String] = [:]) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)"
        return RxAlamofire
            .requestData(.get,
                         absolutePath,
                         parameters: parameters,
                         encoding: encoding,
                         headers: headers)
            .observeOn(scheduler)
            .mapObject(type: T.self, errorType: GrailedError.self)
    }

    func postItem(_ path: String,
              parameters: [String: Any]? = nil,
              headers: [String: String] = [:]) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)"
        return RxAlamofire
            .requestData(.post,
                         absolutePath,
                         parameters: parameters,
                         encoding: JSONEncoding.default,
                         headers: headers)
            .observeOn(scheduler)
            .mapObject(type: T.self, errorType: GrailedError.self)
    }
    
    func putItem(_ path: String,
             parameters: [String: Any]? = nil,
             headers: [String: String] = [:]) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)"
        return RxAlamofire
            .requestData(.put,
                         absolutePath,
                         parameters: parameters,
                         encoding: JSONEncoding.default,
                         headers: headers)
            .observeOn(scheduler)
            .mapObject(type: T.self, errorType: GrailedError.self)
    }
    
    func deleteItem(_ path: String,
                parameters: [String: Any] = [:],
                headers: [String: String] = [:]) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)"
        return RxAlamofire
            .requestData(.delete,
                         absolutePath,
                         headers: headers)
            .observeOn(scheduler)
            .mapObject(type: T.self, errorType: GrailedError.self)
    }
    
}
