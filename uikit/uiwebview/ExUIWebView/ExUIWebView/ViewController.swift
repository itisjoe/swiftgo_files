//
//  ViewController.swift
//  ExUIWebView
//
//  Created by joe feng on 2016/5/19.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIWebViewDelegate {
    var myTextField :UITextField!
    var myWebView :UIWebView!
    var myActivityIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 取得螢幕的尺寸
        let fullScreenSize = UIScreen.mainScreen().bounds.size
        
        // 預設尺寸
        let goWidth = 100.0
        let actionWidth = ( Double(fullScreenSize.width) - goWidth ) / 4

        
        // 建立五個 UIButton
        var myButton = UIButton(frame: CGRect(x: 0, y: 20, width: actionWidth, height: actionWidth))
        myButton.setImage(UIImage(named: "back")!, forState: .Normal)
        myButton.addTarget(self, action: #selector(ViewController.back), forControlEvents: .TouchUpInside)
        self.view.addSubview(myButton)
        
        myButton = UIButton(frame: CGRect(x: actionWidth, y: 20, width: actionWidth, height: actionWidth))
        myButton.setImage(UIImage(named: "forward")!, forState: .Normal)
        myButton.addTarget(self, action: #selector(ViewController.forward), forControlEvents: .TouchUpInside)
        self.view.addSubview(myButton)
        
        myButton = UIButton(frame: CGRect(x: actionWidth * 2, y: 20, width: actionWidth, height: actionWidth))
        myButton.setImage(UIImage(named: "refresh")!, forState: .Normal)
        myButton.addTarget(self, action: #selector(ViewController.reload), forControlEvents: .TouchUpInside)
        self.view.addSubview(myButton)

        myButton = UIButton(frame: CGRect(x: actionWidth * 3, y: 20, width: actionWidth, height: actionWidth))
        myButton.setImage(UIImage(named: "stop")!, forState: .Normal)
        myButton.addTarget(self, action: #selector(ViewController.stop), forControlEvents: .TouchUpInside)
        self.view.addSubview(myButton)
        
        myButton = UIButton(frame: CGRect(x: Double(fullScreenSize.width) - goWidth, y: 20, width: goWidth, height: actionWidth))
        myButton.setTitle("前往", forState: .Normal)
        myButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        myButton.addTarget(self, action: #selector(ViewController.go), forControlEvents: .TouchUpInside)
        self.view.addSubview(myButton)
        
        // 建立一個 UITextField 用來輸入網址
        myTextField = UITextField(frame: CGRect(x: 0, y: 20.0 + CGFloat(actionWidth), width: fullScreenSize.width, height: 40))
        myTextField.text = "https://www.google.com"
        myTextField.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        myTextField.clearButtonMode = .WhileEditing
        myTextField.returnKeyType = .Go
        myTextField.delegate = self
        self.view.addSubview(myTextField)

        // 建立 UIWebView
        myWebView = UIWebView(frame: CGRect(x: 0, y: 60.0 + CGFloat(actionWidth), width: fullScreenSize.width, height: fullScreenSize.height - 60 - CGFloat(actionWidth)))

        // 設置委任對象
        myWebView.delegate = self
        
        // 加入到畫面中
        self.view.addSubview(myWebView)
        
        // 建立環狀進度條
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
        myActivityIndicator.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.5)
        self.view.addSubview(myActivityIndicator);
        
        // 先讀取一次網址
        self.go()
    }
    
    func back() {
        // 上一頁
        myWebView.goBack()
    }

    func forward() {
        // 下一頁
        myWebView.goForward()
    }
    
    func reload() {
        // 重新讀取
        myWebView.reload()
    }
    
    func stop() {
        // 取消讀取
        myWebView.stopLoading()
        
        // 隱藏環狀進度條
        myActivityIndicator.stopAnimating()
    }
    
    func go() {
        // 隱藏鍵盤
        self.view.endEditing(true)

        // 前往網址
        let url = NSURL(string:myTextField.text!)
        let urlRequest = NSURLRequest(URL: url!)
        myWebView.loadRequest(urlRequest)
        
        // 你也可以設置 HTML 內容到一個常數
        // 用來載入一個靜態的網頁內容
        // let content = "<html><body><h1>Hello World !</h1></body></html>"
        // myWebView.loadHTMLString(content, baseURL: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.go()
        
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        // 顯示進度條
        myActivityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // 隱藏進度條
        myActivityIndicator.stopAnimating()
        
        // 更新網址列的內容
        if let currentURL = myWebView.request?.URL!.absoluteString {
            myTextField.text = currentURL
        }
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

