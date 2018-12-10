//
//  SearchListViewModel.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import RxOptional

// MARK: - SavedSearchViewModel
struct SavedSearchViewModel {
    let savedSearch: SavedSearch
    let name: String
    let imageUrl: URL?
}

final class SearchListViewModel {
    
    // MARK: - Input
    struct Input {
        let viewDidLoad$: Observable<Void>
        let didSelectCell$: Observable<IndexPath>
    }
    
    // MARK: - Output
    struct Output {
        let savedSearchList$: Driver<[SavedSearchViewModel]>
        let loading$: Driver<Bool>
        let error$: Driver<Error>
    }
    
    // MARK: - Initalization
    private let disposeBag = DisposeBag()
    private let network: SavedSearchNetworkable
    
    init(network: SavedSearchNetworkable = SavedSearchNetwork.shared) {
        self.network = network
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        /// Rx Properties
        let _network = network
        let _errorTracker = ErrorTracker()
        let _activityTracker = ActivityTracker()
        
        /// Helper Methods
        let mapSavedSearchToViewModel: (SavedSearch) -> SavedSearchViewModel = {
            return SavedSearchViewModel(savedSearch: $0,
                                        name: $0.name.capitalized,
                                        imageUrl: URL(string: $0.image_url))
        }
        
        /// Saved Search List Observable
        let savedSearchList$ = input.viewDidLoad$
            .flatMapLatest { _ in
                _network.fetchAll()
                    .trackActivity(_activityTracker)
                    .trackError(_errorTracker)
            }
            .map { $0.data.map { mapSavedSearchToViewModel($0) } }
        
        return Output(savedSearchList$: savedSearchList$.asDriverOnErrorJustComplete(),
                      loading$: _activityTracker.asDriver(),
                      error$: _errorTracker.asDriver())
    }
    
}

