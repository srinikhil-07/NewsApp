//
//  NewsWebViewController.swift
//  GoodNews
//
//  Created by sri-7348 on 4/7/20.
//  Copyright © 2020 Nikhil. All rights reserved.
//

import Foundation
import SafariServices

class NewsWebViewController: UIViewController, SFSafariViewControllerDelegate {
    var newsWebURL: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = SFSafariViewController(url: newsWebURL)
        vc.delegate = self
        present(vc, animated: true)
    }
}
