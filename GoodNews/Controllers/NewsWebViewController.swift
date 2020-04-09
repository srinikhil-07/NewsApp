//
//  NewsWebViewController.swift
//  GoodNews
//
//  Created by sri-7348 on 4/7/20.
//  Copyright © 2020 Nikhil. All rights reserved.
//

import Foundation
import WebKit

class NewsWebViewController: UIViewController, WKUIDelegate {
    var newsWebURL: URL!
    @IBOutlet var newsWebView: WKWebView!
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        newsWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        newsWebView.uiDelegate = self
        view = newsWebView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let myRequest = URLRequest(url: newsWebURL)
        newsWebView.load(myRequest)
    }
}
