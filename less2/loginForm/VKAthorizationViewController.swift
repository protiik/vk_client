//
//  VKAthorizationViewController.swift
//  loginForm
//
//  Created by prot on 17.03.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit
import WebKit

class VKAthorizationViewController: UIViewController {
    
    @IBOutlet weak var aView1: UIView!
    @IBOutlet weak var aView2: UIView!
    @IBOutlet weak var aView3: UIView!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7436631"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "270342"),
//            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.52")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        webView.navigationDelegate = self
        webView.load(request)
        
        downloadView()
        
    }
    
    
    func downloadView () {
        aView1.layer.cornerRadius = aView1.frame.height / 2
        aView2.layer.cornerRadius = aView2.frame.height / 2
        aView3.layer.cornerRadius = aView3.frame.height / 2
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.aView1.alpha = 0.5
            
        })
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.aView2.alpha = 0.5
            
            
        })
        UIView.animate(withDuration: 0.4, delay: 0.3, options: [.repeat, .autoreverse], animations: {
            self.aView3.alpha = 0.5
            
            
        })
    }
}

extension VKAthorizationViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let token = params["access_token"]
        
//        Session.shared.token = token ?? ""
        Session.shared.token = "a38a31ab8b9114b469783b969a24c571f462453f7016f2b2ab7a22f8acf805ae5fbfc74d09876c9ec61da"
        print(token ?? "")
        
        
        decisionHandler(.cancel)
        
        if !(token?.isEmpty ?? false) {
            self.dismiss(animated: false) {
                self.performSegue(withIdentifier: "goSegue", sender: self)
            }
        }
    }
}

