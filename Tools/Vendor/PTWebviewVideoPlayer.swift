//
//  PTWebviewVideoPlayer.swift
//  PTPark
//
//  Created by CHEN KAIDI on 22/5/2017.
//
//

import UIKit
import WebKit

class PTWebviewVideoPlayer: UIView {

    var _coverImageView:UIImageView?
    
    fileprivate var _playButton:UIImageView?
    var _webView:WKWebView?
    fileprivate var videoReady = false
    
    override init (frame:CGRect){
        super.init(frame: frame)
        self.addSubview(webView)
        self.addSubview(coverImageView)
        self.addSubview(playButton)
//        NotificationCenter.default.addObserver(self, selector: #selector(hideButton), name:NSWindowDidEnterFullScreen, object: nil)
    }
    
    deinit {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setAttribute(imageURL:String, videoURL:URL?, autoLoadH5:Bool){
        if let videoURL = videoURL {
            if !videoReady{
                print("video URL: \(videoURL.absoluteString)")
                if autoLoadH5{
                    self.webView.load(URLRequest(url:videoURL))
                    self.playButton.isHidden = false
                } 
            }
        }
        self.coverImageView.loadImage(url: URL(string:imageURL))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.coverImageView.frame = self.bounds
        self.playButton.frame = self.bounds
        self.webView.frame = self.bounds
    }
    
    @objc func hideButton(){
        self.coverImageView.isHidden = true
        self.playButton.isHidden = true
    }
    
    func stopVideo(){
        print("Stop Video")
        self.webView.stopLoading()
//        self.webView.evaluateJavaScript("window.pt_dispatch('stopVideo')", completionHandler:nil)
        let dict = ["type":"stopVideo"]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            if let convertedString = String(data: jsonData, encoding: String.Encoding.utf8){
                self.webView.evaluateJavaScript("window.pt_dispatch('stopVideo',\(convertedString))", completionHandler:nil)
            }
            
        } catch { print(error.localizedDescription) }
    }
    
    var coverImageView:UIImageView{
        if _coverImageView == nil {
            _coverImageView = UIImageView(frame: self.bounds)
            _coverImageView?.contentMode = .scaleAspectFill
            _coverImageView?.backgroundColor = .zircon
            _coverImageView?.clipsToBounds = true
        }
        return _coverImageView!
    }
    
    fileprivate var playButton:UIImageView{
        if _playButton == nil {
            _playButton = UIImageView(frame: self.bounds)
            _playButton?.image = UIImage(named: "btn_64_play_w_nor")
            _playButton?.contentMode = .center
            _playButton?.isHidden = true
        }
        return _playButton!
    }
    
    fileprivate var webView:WKWebView{
        if _webView == nil {
            _webView = WKWebView(frame: self.bounds, configuration: WKWebViewConfiguration())
            _webView?.scrollView.isScrollEnabled = false
            _webView?.navigationDelegate = self
        }
        return _webView!
    }
    
}

extension PTWebviewVideoPlayer:WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlString = navigationAction.request.url?.absoluteString
        if let _urlString = urlString?.removingPercentEncoding, _urlString.hasPrefix("putao://openNativeView/") == true {
            let index = _urlString.index(_urlString.startIndex, offsetBy: 23)
            let param = _urlString.substring(from: index)
            let jsonData = param.data(using: .utf8)
            let jsonDict = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments)
            if let dict = jsonDict as? Dictionary<String,Any> {
                let type = dict["type"] as? String
                if type == "videoStart"{
                    self.coverImageView.isHidden = true
                    self.playButton.isHidden = true
                }
            }
            decisionHandler(.allow)
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Cell video ready")
        videoReady = true
    }
}
