//
//  DetailsViewController.swift
//  ThreeJSExample
//
//  Created by Chedi BACCARI on 28/10/2019.
//  Copyright © 2019 Chedi BACCARI. All rights reserved.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentedColors: UISegmentedControl!
    
    var selectedItem: Int?
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        guard let selected: Int = selectedItem else {
            return
        }
        initWebView()
        
        showContent(selected: selected)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        webView.removeFromSuperview()
    }
    
    @IBAction func colorChanged(_ sender: Any) {
        /// Send data to JS code.
        switch segmentedColors.selectedSegmentIndex {
        case 0:
            webView.evaluateJavaScript("setBackgroundColor('red')")
        case 1:
            webView.evaluateJavaScript("setBackgroundColor('green')")
        case 2:
            webView.evaluateJavaScript("setBackgroundColor('blue')")
        default:
            break
        }
    }
    private func initWebView() {
        /// Setup the WKWebView callback to handle events created by the JS code.
        let contentController = WKUserContentController();
        contentController.add(self, name: "callback")
        
        /// Setup WKWebView configuration
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        /// Enable the access to JS modules and textures files that are used by three.js
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        /// Add the WKWebView as a subview of webViewContainer
        webView = WKWebView(frame: webViewContainer.bounds, configuration: config)
        webViewContainer.addSubview(webView)
        webView.navigationDelegate = self
    }
    
    private func showContent(selected: Int) {
        /// Load content in WKWebView
        switch selected {
        case 0:
            /// Load a web url
            segmentedColors.isHidden = true
            if let url = URL(string: "https://threejs.org/examples/#webgl_animation_cloth") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        case 1:
            /// Load a local html file.
            segmentedColors.isHidden = true
            if let url = Bundle.main.url(forResource: "1", withExtension: "html") {
                webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            }
        case 2:
            /// Load a local html file.
            segmentedColors.isHidden = false
            if let url = Bundle.main.url(forResource: "2", withExtension: "html") {
                webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            }
        case 3:
            /// Load a local html file that uses three.js object without textures.
            segmentedColors.isHidden = true
            if let url = Bundle.main.url(forResource: "3", withExtension: "html", subdirectory: "threejs") {
                webView.loadFileURL(url, allowingReadAccessTo: url)
                let request = URLRequest(url: url)
                webView.load(request)
            }
        case 4:
            /// Load a local html file that uses three.js object with textures and JS modules.
            segmentedColors.isHidden = true
            if let url = Bundle.main.url(forResource: "webgl_animation_keyframes", withExtension: "html", subdirectory: "threejs/web/examples") {
                webView.loadFileURL(url, allowingReadAccessTo: url)
                let request = URLRequest(url: url)
                webView.load(request)
            }
        default:
            print(selected)
        }
    }
}

extension DetailsViewController: WKNavigationDelegate, WKScriptMessageHandler {
    /// Receive data from JS code
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let msg = message.body as? String else {
            return
        }
        let alert = UIAlertController(title: "Message from JS", message: "\(msg) was clicked !", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
    }
}
