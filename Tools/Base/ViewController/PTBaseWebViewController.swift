//
//  PTBaseWebViewController.swift
//  PTPark
//
//  Created by soso on 2017/6/13.
//
//

import UIKit
import WebKit

class PTBaseWebViewController: PTBaseViewController, WKNavigationDelegate {
    
    var url: URL?
    
    // MARK: Life cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.view.addSubview(webView)
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = self.view.bounds
    }
    
    func loadData() {
        guard let `url` = url else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    // MARK: Lazy
    fileprivate lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let web = WKWebView(frame: self.view.bounds, configuration: config)
        return web
    }()
    
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let title = webView.title else {
            return
        }
        self.title = title
    }
    
}
