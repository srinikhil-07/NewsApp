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
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    private var page = 0
    override func viewDidLoad() {
        self.page = 1
        super.viewDidLoad()
        setupView()
        setupActivityIndicator()
        tableView.rowHeight = UITableView.automaticDimension
    }
    private func setupView() {
        var dataFetched = false
        print("Setting up view")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        activityIndicator.startAnimating()
        print("Fetching Webservice articles")
        WebService().getArticles(for: newsURL, with: page) { articles in
            if let articles = articles {
                dataFetched = true
                self.page = self.page + 1
                self.articleListViewModel = ArticleListViewModel(articles)
            } else {
                print("No data")
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if dataFetched {
                    self.tableView.reloadData()
                } else {
                    let alert = UIAlertController.init(title: "Fetch Failed", message: "Swipe down to retry", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .default) {
                        (UIAlertAction) -> Void in
                    }
                    alert.addAction(alertAction)
                    self.present(alert, animated: true)
                    {
                        () -> Void in
                    }
                }
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
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (endScrolling >= scrollView.contentSize.height)
        {
            print("fetching new news articles")
            fetchAdditionalNewsArticles()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleAtCell = self.articleListViewModel.articleAtIndex(indexPath.row)
        let urlString = articleAtCell.articleURL
        if let url = URL(string: urlString) {
            performSegue(withIdentifier: "NewsView", sender: url)
        } else {
            print("Error in forming URL")
        }
    }
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
        activityIndicator.hidesWhenStopped = true
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
// MARK: - Dynamically append news items
extension NewsListenerController {
    func fetchAdditionalNewsArticles() {
        print("Fetching addtional news articles: \(self.page)")
        WebService().getArticles(for: self.newsURL, with: self.page) { articles in
            if let newArticles = articles {
                self.page = self.page + 1
                let intialCount = self.articleListViewModel.numberOfRowsInSection(0)
                self.articleListViewModel.add(newArticles: newArticles)
                DispatchQueue.main.async {
                    let finalCount = self.articleListViewModel.numberOfRowsInSection(0)
                    let indexPaths = (intialCount ..< finalCount).map {
                        IndexPath(row: $0, section: 0)
                    }
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                    self.tableView.endUpdates()
                }
            } else {
                print("No data for page: \(self.page)")
            }
        }
    }
}
