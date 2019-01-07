//
//  SearchDetailViewModel.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/18/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import RxOptional

final class SavedSearchDetailViewModel {
    
    // MARK: - Input
    struct Input { }
    
    // MARK: - Output
    struct Output {
        let savedSearch$: Driver<SavedSearchViewModel>
    }
    
    // MARK: - Initalization
    private let disposeBag = DisposeBag()
    
    // MARK: - Coordinator Outputs
    let displaySelectedSavedSearch$ = PublishSubject<SavedSearchViewModel>()
    let savedSearch: SavedSearchViewModel
    
    init(savedSearch: SavedSearchViewModel) {
        self.savedSearch = savedSearch
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        return Output(savedSearch$: Driver.of(savedSearch).asSharedSequence())
    }
    
}
