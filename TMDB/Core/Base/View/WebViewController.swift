//
//  WebViewController.swift
//  TMDB
//
//  Created by Azis Ramdhan on 06/12/21.
//

import UIKit
import WebKit

class WebViewController: BaseViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var youtubeURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = youtubeURL else {
            showMessage("Invalid URL", action: { [weak self] _ in
                self?.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
}
