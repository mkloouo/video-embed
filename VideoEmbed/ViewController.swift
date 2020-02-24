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
    var slider: UISlider!
    var playButton: UIButton!
    
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
        
        self.slider = UISlider()
        self.slider.minimumValue = 0
        self.slider.maximumValue = 100
        self.slider.value = 31.0
        self.slider.addTarget(self, action: #selector(handleSliderDragInside), for: .touchDragInside)
        
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.slider)
        
        self.slider.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.slider.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        
        self.slider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.slider.topAnchor.constraint(equalTo: self.webView.bottomAnchor, constant: 20).isActive = true
        
        self.playButton = UIButton(type: .system)
        self.playButton.setTitle("Play", for: .normal)
        self.playButton.addTarget(self, action: #selector(handlePlayButtonClick), for: .touchUpInside)
        
        self.playButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.playButton)
        
        self.playButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.playButton.topAnchor.constraint(equalTo: self.slider.bottomAnchor, constant: 20).isActive = true
    }
    
    @objc
    func handleSliderDragInside() {
        print("slider value: \(self.slider.value)")
    }
    
    @objc
    func handlePlayButtonClick() {
        print("clicked button")
    }

}

