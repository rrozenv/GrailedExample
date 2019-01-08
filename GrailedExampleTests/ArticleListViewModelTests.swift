//
//  ArticleListViewModelTests.swift
//  GrailedExampleTests
//
//  Created by Robert Rozenvasser on 12/29/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import XCTest
import RxTest
import RxBlocking
import RxSwift
import RxCocoa
@testable import GrailedExample

class ArticleListViewModelTests: XCTestCase {

    // MARK: - Properties
    var viewModel: ArticleListViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    var disposeBag = DisposeBag()
    var _viewDidLoad: PublishSubject<Void>!
    var _willDisplayCell: PublishSubject<IndexPath>!
    var _didSelectCell: PublishSubject<IndexPath>!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        viewModel = ArticleListViewModel(network: ArticlesNetworkMock())
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        _viewDidLoad = PublishSubject<Void>()
        _willDisplayCell = PublishSubject<IndexPath>()
        _didSelectCell = PublishSubject<IndexPath>()
    }
    
    override func tearDown() {
        super.tearDown()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Helper Methods
    @discardableResult
    private func createOutputs() -> ArticleListViewModel.Output {
        let inputs = ArticleListViewModel.Input(viewDidLoad$: _viewDidLoad.asObservable(),
                                                willDisplayCell$: _willDisplayCell.asObservable(),
                                                didSelectCell$: _didSelectCell.asObservable())
        
        return viewModel.transform(input: inputs)
    }
    
    // MARK: - Tests
    func test_article_list_display() {
        /// Given
        let testScheduler = TestScheduler(initialClock: 0)
        let observer = testScheduler.createObserver([ArticleListSection].self)
        
        let outputs = createOutputs()
        outputs
            .articleListSections$.asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        testScheduler.start()
        
        /// When
        _viewDidLoad.onNext(())
        
        /// Then
        // 1. Add Loading Section
        // 2. Remove Loading Section
        // 3. Add Article List Section
        XCTAssert(observer.events.count == 3)
        XCTAssert(observer.events.first?.value.element?.count == 1)
        XCTAssert(observer.events.first?.value.element?.first?.title == ArticleListViewModel.Constants.loadingSectionTitle)
    }
    
    func test_article_pagination() {
        /// Given
        let testScheduler = TestScheduler(initialClock: 0)
        let observer = testScheduler.createObserver([ArticleListSection].self)
        
        let outputs = createOutputs()
        outputs
            .articleListSections$.asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        testScheduler.start()
        
        /// When
        _viewDidLoad.onNext(())
        _willDisplayCell.onNext(IndexPath(row: 2, section: 0))
        
        /// Then
        // 1. Add Loading Section
        // 2. Remove Loading Section
        // 3. Add Article List Section
        let firstSection = observer.events[2].value.element?[0]
        let secondSection = observer.events[5].value.element?[1]
        XCTAssert(observer.events.count == 6)
        XCTAssert(firstSection?.items.count == 3)
        XCTAssert(secondSection?.items.count == 4)
    }
    
    func test_error() {
        /// Given
        let service = ArticlesNetworkMock()
        service.shouldError.accept(true)
        viewModel = ArticleListViewModel(network: service)
        
        let testScheduler = TestScheduler(initialClock: 0)
        let observer = testScheduler.createObserver(Error.self)
        
        let outputs = createOutputs()
        outputs
            .error$.asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        testScheduler.start()
        
        /// When
        _viewDidLoad.onNext(())
        
        /// Then
        XCTAssert(observer.events.count == 1)
        XCTAssert((observer.events.first?.value.element as? NetworkError) != nil)
    }

}

final class ArticlesNetworkMock: ArticlesNetworkable {
    
    var shouldError = BehaviorRelay(value: false)
    
    let firstArticleSet = [
        Article(id: 0, url: "", title: "First Article", author: "First Author"),
        Article(id: 1, url: "", title: "Second Article", author: "Second Author"),
        Article(id: 2, url: "", title: "Third Article", author: "Third Author"),
    ]
    
    let secondArticleSet = [
        Article(id: 3, url: "", title: "Fourth Article", author: "Fourth Author"),
        Article(id: 4, url: "", title: "Fifth Article", author: "Fifth Author"),
        Article(id: 5, url: "", title: "Sixth Article", author: "Sixth Author"),
        Article(id: 6, url: "", title: "Seventh Article", author: "Seventh Author")
    ]
    
    func fetchAll(for path: String) -> Observable<ArticlesResult> {
        return Observable.create { [unowned self] observer in
            guard !self.shouldError.value else {
                observer.onError(NetworkError.serverFailed)
                return Disposables.create()
            }
            
            switch path {
            case "api/articles/ios_index":
                let result = ArticlesResult(data: self.firstArticleSet, metadata: MetaData(pagination: Pagination(current_page: "currentPage", next_page: "nextPage", previous_page: "")))
                observer.onNext(result)
            case "nextPage":
                let result = ArticlesResult(data: self.secondArticleSet, metadata: MetaData(pagination: Pagination(current_page: "currentPage", next_page: "nextPage", previous_page: "")))
                observer.onNext(result)
            default: break
            }
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
}
