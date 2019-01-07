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
    
    // MARK: - Coordinator Outputs
    let displaySelectedSavedSearch$ = PublishSubject<SavedSearchViewModel>()
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        
        /// Rx Properties
        let _network = network
        let _errorTracker = ErrorTracker()
        let _activityTracker = ActivityTracker()
        let _savedSearchDataSource = Variable<[SavedSearchViewModel]>([])
        
        /// Creates SavedSearchViewModel data source
        input.viewDidLoad$
            .flatMapLatest { _ in
                _network.fetchAll()
                    .trackActivity(_activityTracker)
                    .trackError(_errorTracker)
            }
            .map { $0.data.map { SavedSearchViewModel($0) } }
            .subscribe(onNext: { _savedSearchDataSource.value.append(contentsOf: $0) })
            .disposed(by: disposeBag)
        
        /// Creates a new saved search
        input.didSelectCell$
            .map { _savedSearchDataSource.value[$0.row] }
            //.flatMapLatest { _ in _network.createNew() }
            .bind(to: displaySelectedSavedSearch$)
            .disposed(by: disposeBag)
        
        /// Adds a new SavedSearch object
        SavedSearch.created$
            .map { SavedSearchViewModel($0) }
            .subscribe(onNext: { _savedSearchDataSource.value.append($0) })
            .disposed(by: disposeBag)
        
        /// Updates an existing SavedSearch object
        SavedSearch.updated$
            .map { SavedSearchViewModel($0) }
            .map { updatedSearch in
                (
                    _savedSearchDataSource.value.firstIndex(where: { $0.id == updatedSearch.id }),
                    updatedSearch
                )
            }
            .subscribe(onNext: { existingIndex, upatedSavedSearch in
                guard let existingIndex = existingIndex else { return }
                _savedSearchDataSource.value[existingIndex] = upatedSavedSearch
            })
            .disposed(by: disposeBag)
        
        /// Deletes an existing SavedSearch object
        SavedSearch.deleted$
            .map { deletedSearch in
                _savedSearchDataSource.value.firstIndex(where: { $0.id == deletedSearch.id })
            }
            .filterNil()
            .subscribe(onNext: { existingIndex in
                _savedSearchDataSource.value.remove(at: existingIndex)
            })
            .disposed(by: disposeBag)
        
        return Output(savedSearchList$: _savedSearchDataSource.asDriver(),
                      loading$: _activityTracker.asDriver(),
                      error$: _errorTracker.asDriver())
    }
    
}

// MARK: - SavedSearchViewModel
struct SavedSearchViewModel {
    let savedSearch: SavedSearch
    var id: Int { return savedSearch.id }
    var name: String { return savedSearch.name.capitalized }
    var imageUrl: URL? { return URL(string: savedSearch.image_url) }
    
    init(_ savedSearch: SavedSearch) {
        self.savedSearch = savedSearch
    }
}


