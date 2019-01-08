//
//  SavedSearchNetwork.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift

protocol SavedSearchNetworkable {
    func fetchAll() -> Observable<SavedSearchResult>
    func createNew() -> Observable<Void>
}

final class SavedSearchNetwork: SavedSearchNetworkable {
    
    static let shared = SavedSearchNetwork(network: Network<SavedSearchResult>(Environment.rootURL.absoluteString))
    static let savedSearchStoreChanged = Notification.Name("SavedSearchStoreChanged")

    // MARK: - Initalization
    private let network: Network<SavedSearchResult>
    
    private init(network: Network<SavedSearchResult>) {
        self.network = network
    }
    
    func fetchAll() -> Observable<SavedSearchResult> {
        let cachedResult = Storage.retrieve(from: .documents, as: SavedSearchResult.self).asObservable()
        let networkResult = network.getItem("api/merchandise/marquee")
            .flatMap { result -> Observable<SavedSearchResult> in
                return Storage.store(result, to: .documents)
                    .asObservable()
                    .mapObject(type: SavedSearchResult.self, errorType: GrailedError.self)
                    .concat(Observable.just(result))
        }
        return cachedResult.concat(networkResult)
    }
    
    func createNew() -> Observable<Void> {
        return Observable.of(())
            .do(onNext: {
                NotificationCenter.default.post(name: SavedSearch.created,
                                                object: SavedSearch(id: 1001, name: "New", image_url: ""),
                                                userInfo: nil)
            })
            .mapToVoid()
    }

}
