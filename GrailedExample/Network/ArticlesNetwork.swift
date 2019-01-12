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
    func favorite(article: Article) -> Observable<Article>
    func fetchFavoritedArticles() -> Observable<[Article]>
}

final class ArticlesNetwork: ArticlesNetworkable {
    
    static let shared = ArticlesNetwork(network: Network<ArticlesResult>(Constants.baseUrl))
    var favoritedArticles = [Article]()
    
    // MARK: - Initalization
    private let network: Network<ArticlesResult>
    
    private init(network: Network<ArticlesResult>) {
        self.network = network
    }
    
    func fetchAll(for path: String) -> Observable<ArticlesResult> {
        return network.getItem(path)
    }
    
    func favorite(article: Article) -> Observable<Article> {
        if let index = favoritedArticles.index(where: { $0.id == article.id }) {
            favoritedArticles.remove(at: index)
            NotificationCenter.default.post(name: Article.unfavorited, object: article)
        } else {
           favoritedArticles.append(article)
           NotificationCenter.default.post(name: Article.favorited, object: article)
        }
        return .just(article)
    }
    
    func fetchFavoritedArticles() -> Observable<[Article]> {
       return .just(favoritedArticles)
    }

}

