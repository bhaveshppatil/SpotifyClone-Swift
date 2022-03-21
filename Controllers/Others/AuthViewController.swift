//
//  AuthViewController.swift
//  SpotifyClone-Swift
//
//  Created by Perennial Macbook on 17/03/22.
//

import UIKit
import WebKit
class AuthViewController: UIViewController, WKNavigationDelegate{
    
    private let webView : WKWebView = {
        
        let pref = WKWebpagePreferences()
        pref.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = pref
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()

    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.backgroundColor = .systemBackground
        guard let url = AuthManager.shared.signInURL else { return }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        
    print("Code: \(code)")
    }
}
