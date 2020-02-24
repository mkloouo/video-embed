//
//  ViewController.swift
//  VideoEmbed
//
//  Created by Mykola Odnosumov on 24.02.2020.
//  Copyright © 2020 Mykola Odnosumov. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class ViewController: UIViewController {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        let videoUrl = URL(string: "https://www.wix.com/video-embed?social=weed")
        let videoRequest = URLRequest(url: videoUrl!)
        self.webView = WKWebView()
        self.webView.load(videoRequest)
        
        self.webView.backgroundColor = .white
        
        self.webView.layer.borderWidth = 1
        self.webView.layer.borderColor = UIColor(ciColor: .black).cgColor
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(webView)
        
        self.webView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.webView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height / 2).isActive = true
        
        self.webView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    }

}

