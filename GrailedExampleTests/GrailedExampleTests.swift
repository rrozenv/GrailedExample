//
//  GrailedExampleTests.swift
//  GrailedExampleTests
//
//  Created by Robert Rozenvasser on 12/4/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import XCTest
import RxTest
import RxBlocking
import RxSwift
import RxCocoa
@testable import GrailedExample

class GrailedExampleTests: XCTestCase {
    
    // MARK: - Properties
    var viewModel: SearchListViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    var disposeBag = DisposeBag()
    var _viewDidLoad: PublishSubject<Void>!
    var _didSelectCell: PublishSubject<IndexPath>!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        viewModel = SearchListViewModel(network: SavedSearchServiceMock())
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        
        _viewDidLoad = PublishSubject<Void>()
        _didSelectCell = PublishSubject<IndexPath>()
    }
    
    override func tearDown() {
        super.tearDown()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Helper Methods
    @discardableResult
    private func createOutputs() -> SearchListViewModel.Output {
        let inputs = SearchListViewModel.Input(viewDidLoad$: _viewDidLoad.asObservable(),
                                               didSelectCell$: _didSelectCell.asObservable())
        
        return viewModel.transform(input: inputs)
    }

    // MARK: - Tests
    func test_saved_search_list_display() {
        /// Given
        let testScheduler = TestScheduler(initialClock: 0)
        let observer = testScheduler.createObserver([SavedSearchViewModel].self)
    
        let outputs = createOutputs()
        outputs
            .savedSearchList$.asObservable()
            .skip(1) // Skip inital emit of `Driver` value
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        testScheduler.start()
        
        /// When
        _viewDidLoad.onNext(())
        
        /// Then
        XCTAssert(observer.events.count == 1)
        XCTAssert(observer.events.first?.value.element?.count == 3)
    }
    
    func test_display_saved_search() {
        /// Given
        let testScheduler = TestScheduler(initialClock: 0)
        let observer = testScheduler.createObserver(SavedSearchViewModel.self)
        
        createOutputs()
        
        viewModel.displaySelectedSavedSearch$
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        testScheduler.start()
   
        /// When
        _viewDidLoad.onNext(())
        _didSelectCell.onNext(IndexPath(row: 2, section: 0))
        
        /// Then
        XCTAssert(observer.events.first?.value.element?.name == "Third Search")
    }
    
    func test_error() {
        /// Given
        let service = SavedSearchServiceMock()
        service.shouldError.accept(true)
        viewModel = SearchListViewModel(network: service)
        
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
    
    func test_loading() {
        /// Given
        let testScheduler = TestScheduler(initialClock: 0)
        let observer = testScheduler.createObserver(Bool.self)
        
        let outputs = createOutputs()
        outputs
            .loading$.asObservable()
            .skip(1) // Skip inital emit of `Driver` value
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        testScheduler.start()
        
        /// When
        _viewDidLoad.onNext(())
        
        /// Then
        XCTAssert(observer.events.count == 2)
        XCTAssertTrue((observer.events.first?.value.element)!)
        XCTAssertFalse((observer.events.last?.value.element)!)
    }
    
    func test_add_new_saved_search() {
        /// Given
        let testScheduler = TestScheduler(initialClock: 0)
        let observer = testScheduler.createObserver([SavedSearchViewModel].self)
        
        let outputs = createOutputs()
        outputs
            .savedSearchList$.asObservable()
            .skip(1) // Skip inital emit of `Driver` value
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        testScheduler.start()
        
        /// When
        _viewDidLoad.onNext(())
        NotificationCenter.default.post(name: SavedSearch.created,
                                        object: SavedSearch(id: 3, name: "New Search", image_url: ""),
                                        userInfo: nil)
        
        /// Then
        XCTAssert(observer.events.count == 2)
        XCTAssert(observer.events.first?.value.element?.count == 3)
        XCTAssert(observer.events.last?.value.element?.count == 4)
    }
    
    func test_update_saved_search() {
        /// Given
        let testScheduler = TestScheduler(initialClock: 0)
        let observer = testScheduler.createObserver([SavedSearchViewModel].self)
        
        let outputs = createOutputs()
        outputs
            .savedSearchList$.asObservable()
            .skip(1) // Skip inital emit of `Driver` value
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        testScheduler.start()
        
        /// When
        _viewDidLoad.onNext(())
        NotificationCenter.default.post(name: SavedSearch.updated,
                                        object: SavedSearch(id: 2, name: "Updated Search", image_url: ""),
                                        userInfo: nil)
        
        /// Then
        XCTAssert(observer.events.count == 2)
        XCTAssert(observer.events.first?.value.element?.count == 3)
        XCTAssert(observer.events.last?.value.element?.count == 3)
        XCTAssert(observer.events.last?.value.element?[2].name == "Updated Search")
    }
    
    func test_delete_saved_search() {
        /// Given
        let testScheduler = TestScheduler(initialClock: 0)
        let observer = testScheduler.createObserver([SavedSearchViewModel].self)
        
        let outputs = createOutputs()
        outputs
            .savedSearchList$.asObservable()
            .skip(1) // Skip inital emit of `Driver` value
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        testScheduler.start()
        
        /// When
        _viewDidLoad.onNext(())
        NotificationCenter.default.post(name: SavedSearch.deleted,
                                        object: SavedSearch(id: 1, name: "Second Search", image_url: ""),
                                        userInfo: nil)
        
        /// Then
        XCTAssert(observer.events.count == 2)
        XCTAssert(observer.events.first?.value.element?.count == 3)
        XCTAssert(observer.events.last?.value.element?.count == 2)
        XCTAssertFalse((observer.events.last?.value.element?.contains(where: { $0.id == 1 }))!)
    }

}

// MARK: - Web Service Mock
class SavedSearchServiceMock: SavedSearchNetworkable {
    
    var shouldError = BehaviorRelay(value: false)
    
    func fetchAll() -> Observable<SavedSearchResult> {
        return Observable.create { [unowned self] observer in
            guard !self.shouldError.value else {
                observer.onError(NetworkError.serverFailed)
                return Disposables.create()
            }
            
            let savedSearches = [
                SavedSearch(id: 0, name: "First Search", image_url: ""),
                SavedSearch(id: 1, name: "Second Search", image_url: ""),
                SavedSearch(id: 2, name: "Third Search", image_url: ""),
            ]
            observer.onNext(SavedSearchResult(data: savedSearches))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func createNew() -> Observable<Void> {
        return .empty()
    }
    
}








/// Given
//        let outputs = createOutputs()
//        let searchList$ = outputs
//            .savedSearchList$.asObservable()
//            .observeOn(MainScheduler.instance)
//
//        /// When
//        _viewDidLoad.onNext(())
//
//        /// Then
//        guard let result = try! searchList$.toBlocking(timeout: 1.0).first() else { return }
//        XCTAssert(result.count == 3)
//        XCTAssert(result.first?.name == "First Search")



/// Given
//        let outputs = createOutputs()
//        let displaySavedSearch$ = viewModel.displaySelectedSavedSearch$.asObservable()
//
//        /// When
//        outputs
//            .savedSearchList$.asObservable()
//            .subscribeOn(scheduler)
//            .subscribe(onNext: { [unowned self] _ in
//                self._didSelectCell.onNext(IndexPath(row: 2, section: 0))
//            })
//            .disposed(by: disposeBag)
//
//        _viewDidLoad.onNext(())
//
//        /// Then
//        guard let result = try! displaySavedSearch$.observeOn(MainScheduler.instance).toBlocking().first()
//            else { return }
//        XCTAssert(result.name == "Third Search")
