//
//  NewsListenerController.swift
//  GoodNews
//
//  Created by sri-7348 on 4/4/20.
//  Copyright © 2020 Nikhil. All rights reserved.
//

import Foundation
import UIKit

class NewsListenerController: UITableViewController {
    private var articleListViewModel: ArticleListViewModel!
    public var newsURL: String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.rowHeight = UITableView.automaticDimension
    }
    private func setupView() {
        print("Setting up view")
        self.navigationController?.navigationBar.prefersLargeTitles = true
                print("Fetching Webservice articles")
                WebService().getArticles(for: newsURL) { articles in
                    if let articles = articles {
                        self.articleListViewModel = ArticleListViewModel(articles: articles)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.articleListViewModel == nil ? 0: self.articleListViewModel.noOfSections
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListViewModel.numberOfRowsInSection(section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableCell", for: indexPath) as? ArticleTableCell else {
            fatalError("Article cell not found")
        }
        let articleAtCell = self.articleListViewModel.articleAtIndex(indexPath.row)
        cell.titleLabel.text = articleAtCell.title
        cell.descriptionLabel.text = articleAtCell.description
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleAtCell = self.articleListViewModel.articleAtIndex(indexPath.row)
        let urlString = articleAtCell.articleURL
        if let url = URL(string: urlString) {
//            UIApplication.shared.open(url) {result in
//                print("URL called: \(result)")
//            }
            performSegue(withIdentifier: "NewsView", sender: url)
        } else {
            print("Error in forming URL")
        }
    }
}
// MARK: -
extension NewsListenerController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue object: \(String(describing: segue))")
        print("sender: \(String(describing: sender))")
        if let destinationVC = segue.destination as? NewsWebViewController {
            if let item = sender as? URL  {
                destinationVC.newsWebURL = item
            }
        }
    }
}
