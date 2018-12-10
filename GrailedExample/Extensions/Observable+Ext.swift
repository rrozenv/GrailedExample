//
//  Observable+Ext.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import RxSwift
import RxCocoa

extension ObservableType {
    
    public func mapObject<T: Codable, E: Error & Codable>(type: T.Type, errorType: E.Type) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            let responseTuple = data as? (HTTPURLResponse, Data)
            
            guard let jsonData = responseTuple?.1,
                  let statusCode = responseTuple?.0.statusCode else {
                return Observable.error(NetworkError.serverFailed)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            guard 200..<300 ~= statusCode else {
                do {
                    let error = try decoder.decode(errorType, from: jsonData)
                    return Observable.error(NetworkError.customError(error))
                } catch {
                    return Observable.error(NetworkError.statusCodeError(statusCode))
                }
            }
            
            do {
                let object = try decoder.decode(T.self, from: jsonData)
                return Observable.just(object)
            } catch {
                return Observable.error(NetworkError.decodingError(String(describing: T.self)))
            }
        }
    }
    
    public func mapArray<T: Codable, E: Error & Codable>(type: T.Type, errorType: E.Type) -> Observable<[T]> {
        return flatMap { data -> Observable<[T]> in
            let responseTuple = data as? (HTTPURLResponse, Data)
            
            guard let jsonData = responseTuple?.1,
                let statusCode = responseTuple?.0.statusCode else {
                    return Observable.error(NetworkError.serverFailed)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            guard 200..<300 ~= statusCode else {
                do {
                    let error = try decoder.decode(errorType, from: jsonData)
                    return Observable.error(NetworkError.customError(error))
                } catch {
                    return Observable.error(NetworkError.statusCodeError(statusCode))
                }
            }
            
            do {
                let objects = try decoder.decode([T].self, from: jsonData)
                return Observable.just(objects)
            } catch {
                return Observable.error(NetworkError.decodingError(String(describing: T.self)))
            }
        }
    }
    
    public func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    public func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    public func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
}

extension SharedSequenceConvertibleType {
    
    public func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }

}


