//
//  ArticleListViewModel.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/4/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import RxOptional

// MARK: - ArticleViewModel
struct ArticleViewModel {
    let uuid = UUID().uuidString // Needed because article `id` does not seem to be unique
    let article: Article
    let title: String
    let author: String
    let url: URL?
    
    init(_ article: Article) {
        self.article = article
        self.title = article.title.capitalized
        self.author = article.author.capitalized
        self.url = URL(string: article.url)
    }
}

final class ArticleListViewModel {
    
    // MARK: - Input
    struct Input {
        let viewDidLoad$: Observable<Void>
        let willDisplayCell$: Observable<IndexPath>
        let didSelectCell$: Observable<IndexPath>
    }
    
    // MARK: - Output
    struct Output {
        let articleListSections$: Driver<[ArticleListSection]>
        let error$: Driver<Error>
    }
    
    // MARK: - Constants
    struct Constants {
        static let loadingSectionTitle = "Loading"
        static let initalPath = "api/articles/ios_index"
    }
   
    // MARK: - Initalization
    private let disposeBag = DisposeBag()
    private let network: ArticlesNetworkable
 
    init(network: ArticlesNetworkable = ArticlesNetwork.shared) {
        self.network = network
    }
    
    // MARK: - Coordinator Outputs
    let displaySelectedArticle$ = PublishSubject<ArticleViewModel>()
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        
        /// Rx Properties
        let _cache = BehaviorRelay<ArticlesResult?>(value: nil)
        let _network = network
        let _errorTracker = ErrorTracker()
        let _activityTracker = ActivityTracker()
        let _articleListSections = Variable<[ArticleListSection]>([
            ArticleListSection(title: Constants.loadingSectionTitle, items: [ArticleListRow.loading])
        ])
        
        /// Helper Methods
        let shouldFetchNextPage: (IndexPath) -> Bool = {
            return _articleListSections.value.count - 1 == $0.section
                && _articleListSections.value[$0.section].items.count - 1 == $0.row
                && !_activityTracker.isLoading
        }
        
        let createSection: (ArticlesResult) -> ArticleListSection = {
            return ArticleListSection(title: UUID().uuidString,
                                      items: $0.data.map { ArticleListRow.article(ArticleViewModel($0)) })
        }
        
        /// Inital Load Trigger
        let initalLoadPath = input.viewDidLoad$.map { Constants.initalPath }
        
        /// Next Page Load Trigger
        let nextPagePath = input
            .willDisplayCell$
            .filter { shouldFetchNextPage($0) }
            .map { _ in _cache.value?.metadata.pagination.next_page }
            .filterNil()
            .distinctUntilChanged()
            .do(onNext: { _ in
                let loadingSection = ArticleListSection(title: Constants.loadingSectionTitle,
                                                        items: [ArticleListRow.loading])
                _articleListSections.value.append(loadingSection)
            })

        /// Fetch Page Observable
        Observable.merge(initalLoadPath, nextPagePath)
            .flatMapLatest { path in
                _network.fetchAll(for: path)
                    .trackActivity(_activityTracker)
                    .trackError(_errorTracker)
            }
            .subscribe(onNext: { result in
                _cache.accept(result)
                _articleListSections.value.removeLast() // Removes loading section
                _articleListSections.value.append(createSection(result))
            })
            .disposed(by: disposeBag)
        
        /// Did Select Cell Observable
        input.didSelectCell$
            .map { idxPath -> ArticleViewModel? in
                switch  _articleListSections.value[idxPath.section].items[idxPath.row] {
                case .article(let article): return article
                default: return nil
                }
            }
            .filterNil()
            .bind(to: displaySelectedArticle$)
//            .subscribe(onNext: { UIApplication.shared.open($0, options: [:]) })
            .disposed(by: disposeBag)

        return Output(articleListSections$: _articleListSections.asDriver(),
                      error$: _errorTracker.asDriver())
    }
    
}

