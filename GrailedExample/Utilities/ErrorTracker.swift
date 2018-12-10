//
//  ErrorTracker.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import RxSwift
import RxCocoa

public class ErrorTracker: SharedSequenceConvertibleType {
    public typealias SharingStrategy = DriverSharingStrategy
    let _subject = PublishSubject<Error>()
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.E> {
        return source.asObservable().do(onError: onError).catchErrorJustComplete()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }
    
    public func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }
    
    private func onError(_ error: Error) {
        _subject.onNext(error)
    }
    
    deinit {
        _subject.onCompleted()
    }
}

extension ObservableType {
    public func trackError(_ errorTracker: ErrorTracker) -> Observable<E> {
        return errorTracker.trackError(from: self)
    }
}

