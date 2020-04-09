//
//  NewsItemController.swift
//  GoodNews
//
//  Created by sri-7348 on 4/5/20.
//  Copyright © 2020 Nikhil. All rights reserved.
//

import Foundation
import UIKit

class NewsItemController: UITableViewController, UISearchBarDelegate {
    let titles = ["Business", "Technology", "Entertainment", "General", "Health","Science", "Sports"]
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        print("The view did load")
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "Search For News"
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected: \(indexPath.row)")
        performSegue(withIdentifier: "NewsItems", sender: "category="+titles[indexPath.row])
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("No.of rows: \(self.titles.count)")
        return self.titles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Call for cell at row: \(indexPath.row)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell", for: indexPath) as? NewsItemCell else {
            fatalError("Article cell not found")
        }
        let newsTitle = titles[indexPath.row]
        cell.newsItem.text = newsTitle
        return cell
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if titles.contains(searchText) {
                performSegue(withIdentifier: "NewsItems", sender: "category="+searchText)
            } else {
                performSegue(withIdentifier: "NewsItems", sender: "q="+searchText)
            }
        } else {
            print("Search text is null")
        }
    }
}
// MARK: - Segue methods
extension NewsItemController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue object: \(String(describing: segue))")
        print("sender: \(String(describing: sender))")
        if let destinationVC = segue.destination as? NewsListenerController {
            if let item = sender as? String  {
                destinationVC.newsURL = item
            }
        }
    }
}
