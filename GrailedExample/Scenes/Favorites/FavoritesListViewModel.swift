//
//  FavoritesListViewModel.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 1/11/19.
//  Copyright © 2019 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import RxOptional

// MARK: - SavedSearchViewModel
//struct FavoritesListViewModel {
//    let savedSearch: SavedSearch
//    let name: String
//    let imageUrl: URL?
//}

final class FavoritesListViewModel {
    
    // MARK: - Input
    struct Input {
        let viewDidLoad$: Observable<Void>
    }
    
    // MARK: - Output
    struct Output {
        let favoritedList$: Driver<[ArticleViewModel]>
    }
    
    // MARK: - Initalization
    private let disposeBag = DisposeBag()
    private let network: ArticlesNetworkable
    
    init(network: ArticlesNetworkable = ArticlesNetwork.shared) {
        self.network = network
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        /// Rx Properties
        let _network = network
        let favoritedList$ = Variable<[ArticleViewModel]>([])
        
        /// Favorited List Observable
        input.viewDidLoad$
            .flatMapLatest { _network.fetchFavoritedArticles() }
            .map { $0.map { ArticleViewModel($0, isFavorited: true) } }
            .bind(to: favoritedList$)
            .disposed(by: disposeBag)
        
        /// Did favorite notification
        Article.favorited$
            .map { ArticleViewModel($0) }
            .subscribe(onNext: {
                favoritedList$.value.append($0)
            })
            .disposed(by: disposeBag)
        
        Article.unfavorited$
            .map { ArticleViewModel($0) }
            .map { article in
                favoritedList$.value.index(where: { $0.article.id == article.article.id })
            }
            .filterNil()
            .subscribe(onNext: {
                favoritedList$.value.remove(at: $0)
            })
            .disposed(by: disposeBag)
        
        return Output(favoritedList$: favoritedList$.asDriver())
    }
    
}
