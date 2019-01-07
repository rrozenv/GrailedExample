//
//  SettingsViewModel.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import RxOptional

final class SettingsViewModel {
    
    // MARK: - Input
    struct Input {
        let didTapLogout$: Observable<Void>
        let didTapChangeTheme$: Observable<Void>
    }
    
    struct Output { }
    
    // MARK: - Initalization
    private let disposeBag = DisposeBag()
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        
        input.didTapChangeTheme$
            .subscribe(onNext: {
                switch Theme.current {
                case .theme1:
                    Theme(rawValue: 1)?.apply()
                case .theme2:
                    Theme(rawValue: 0)?.apply()
                }
            })
            .disposed(by: disposeBag)
        
        input.didTapLogout$
            .subscribe(onNext: { _ in
                NotificationCenter.default.post(name: User.loggedOut, object: nil)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
    
}
