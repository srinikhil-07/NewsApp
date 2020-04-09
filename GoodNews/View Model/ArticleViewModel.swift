//
//  ArticleViewModel.swift
//  GoodNews
//
//  Created by sri-7348 on 4/4/20.
//  Copyright © 2020 Nikhil. All rights reserved.
//

import Foundation

struct ArticleListViewModel {
    let articles: [Article]
}
extension ArticleListViewModel {
    var noOfSections: Int {
        return 1
    }
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.articles.count
    }
    func articleAtIndex(_ index: Int) -> ArticleViewModel {
        let article = self.articles[index]
        return ArticleViewModel(article)
    }
}
struct ArticleViewModel {
    private let article: Article
}
extension ArticleViewModel {
    init(_ article: Article) {
        self.article = article
    }
}
extension ArticleViewModel {
    var title: String {
        return article.title
    }
    var description: String {
        return article.description
    }
    var articleURL: String {
        return article.url
    }
}
