//
//  ArticlesNetwork.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import RxSwift
import Alamofire
import RxSwiftExt

protocol ArticlesNetworkable {
    func fetchAll(for path: String) -> Observable<ArticlesResult>
}

final class ArticlesNetwork: ArticlesNetworkable {
    
    static let shared = ArticlesNetwork(network: Network<ArticlesResult>(Environment.rootURL.absoluteString))
    
    // MARK: - Initalization
    private let network: Network<ArticlesResult>
    
    private init(network: Network<ArticlesResult>) {
        self.network = network
    }
    
    func fetchAll(for path: String) -> Observable<ArticlesResult> {
        return network.getItem(path)
    }

}

