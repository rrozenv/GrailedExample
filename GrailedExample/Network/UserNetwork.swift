//
//  UserNetwork.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import RxSwift
import RxCocoa

final class UserNetwork {
    
    static let shared = UserNetwork(network: Network<User>(Environment.rootURL.absoluteString))
    private let _currentUser = BehaviorRelay<User?>(value: nil)
    var currentUser$: Observable<User> { return _currentUser.asObservable().filterNil() }
    
    // MARK: - Initalization
    private let network: Network<User>
    
    private init(network: Network<User>) {
        self.network = network
    }
    
    func fetchCurrentUser() -> Observable<User?> {
        return Observable.of(User(name: "Rob"))
    }
    
}



