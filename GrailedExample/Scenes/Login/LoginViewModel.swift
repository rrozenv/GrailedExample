//
//  LoginViewModel.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import RxOptional

final class LoginViewModel {
    
    // MARK: - Input
    struct Input {
        let didTapLogin$: Observable<Void>
    }
    
    struct Output { }
    
    // MARK: - Initalization
    private let disposeBag = DisposeBag()
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        input.didTapLogin$
            .subscribe(onNext: { _ in
                let user = User(name: "rob")
                NotificationCenter.default.post(name: User.loggedIn, object: user)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
    
}
