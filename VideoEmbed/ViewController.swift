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

class ViewController: UIViewController, WKScriptMessageHandler {
    
    enum VideoState: String {
        case playing = "Pause"
        case paused = "Play"
    }
    
    var videoState: VideoState = .paused
    
    var webView: WKWebView!
    var slider: UISlider!
    var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let videoUrl = URL(string: "https://www.wix.com/video-embed?social=weed")
        let videoRequest = URLRequest(url: videoUrl!)
        
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.allowsInlineMediaPlayback = true
        webViewConfig.mediaTypesRequiringUserActionForPlayback = []
        webViewConfig.userContentController.add(self, name: "jsHandler")
        
        webView = WKWebView(frame: .zero, configuration: webViewConfig)
        webView.load(videoRequest)
        
        webView.evaluateJavaScript("""
let checkVideoPlayerId;

function updateSliderConstraints() {
    sendToNative({
        initialSliderConfiguration: {
            duration: window.player.getDuration(),
            currentTime: window.player.getCurrentTime()
        }
    });
}

let playing = false;

function handleUpdateSlider() {
    sendToNative({
        updateSlider: {
            playing,
            currentTime: window.player.getCurrentTime()
        }
    });
}

function playVideo() {
    window.player.play();

    if (!playing) playing = true;
    sliderUpdateId = setInterval(handleUpdateSlider, 1000);
}

function pauseVideo() {
    window.player.pause();

    if (playing) playing = false;
    clearInterval(sliderUpdateId);
}

function seekVideo(sec) {
    window.player.seek(sec);

//    if (!playing) playing = true;
//    handleUpdateSlider();
}

function checkVideoPlayer() {
    if (window.player) {
        clearInterval(checkVideoPlayerId);
        sendToNative('video player available');
        sendToNative('seek to: ' + Object.keys(window.player).join(','))
        updateSliderConstraints();

        return;
    }
 
    sendToNative('checked for video player');
}

window.onload = () => {
    checkVideoPlayerId = setInterval(checkVideoPlayer, 1000);
}

function sendToNative(object) {
    window.webkit.messageHandlers.jsHandler.postMessage(object);
}
""");
        
        webView.backgroundColor = .white
        
        webView.layer.borderWidth = 1
        webView.layer.borderColor = UIColor(ciColor: .black).cgColor
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        
        webView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        webView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 2).isActive = true
        
        webView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 31.0
        slider.addTarget(self, action: #selector(handleSliderDragInside), for: .touchDragInside)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(slider)
        
        slider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        slider.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slider.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20).isActive = true
        
        playButton = UIButton(type: .system)
        playButton.setTitle(videoState.rawValue, for: .normal)
        playButton.addTarget(self, action: #selector(handlePlayButtonClick), for: .touchUpInside)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(playButton)
        
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20).isActive = true
    }
    
    @objc
    func handleSliderDragInside() {
        webView.evaluateJavaScript("seekVideo(\(slider.value))")
    }
    
    @objc
    func handlePlayButtonClick() {
        switch (videoState) {
        case .playing:
            videoState = .paused
            webView.evaluateJavaScript("pauseVideo()")
        case .paused:
            videoState = .playing
            webView.evaluateJavaScript("playVideo()")
        }
        
        playButton.setTitle(videoState.rawValue, for: .normal)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "jsHandler") {
            if let body = message.body as? NSDictionary {
                
                if let initialConfig = body.value(forKey: "initialSliderConfiguration") as? NSDictionary {
                    if let duration = initialConfig.value(forKey: "duration") as? NSNumber {
                        slider.maximumValue = duration.floatValue
                    }
                    if let currentTime = initialConfig.value(forKey: "currentTime") as? NSNumber {
                        slider.value = currentTime.floatValue
                    }
                    
                    return
                }
                
                if let updateSlider = body.value(forKey: "updateSlider") as? NSDictionary {
                    if let playing = updateSlider.value(forKey: "playing") as? Bool {
                        videoState = playing ? .playing : .paused
                        playButton.setTitle(videoState.rawValue, for: .normal)
                    }
                    if let currentTime = updateSlider.value(forKey: "currentTime") as? NSNumber {
                        slider.value = currentTime.floatValue
                    }
                    
                    return
                }
                
                
            }
            
            print(message.body)
        }
    }
    
}

