//
//  ViewController.swift
//  ExUIProgressView
//
//  Created by joe feng on 2016/5/19.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 取得螢幕的尺寸
    let fullScreenSize = UIScreen.main.bounds.size
    
    var myProgressView:UIProgressView!
    var myActivityIndicator:UIActivityIndicatorView!
    var myTimer:Timer?
    var myButton:UIButton!
    var count = 0
    let complete = 100

    override func viewDidLoad() {
        super.viewDidLoad()

        // 建立一個 UIProgressView
        myProgressView = UIProgressView(progressViewStyle : .default)
        
        // UIProgressView 的進度條顏色
        myProgressView.progressTintColor = UIColor.blue
        
        // UIProgressView 進度條尚未填滿時底下的顏色
        myProgressView.trackTintColor = UIColor.orange
        
        // 設置尺寸與位置並放入畫面中
        myProgressView.frame = CGRect(x: 0,y: 0,width: fullScreenSize.width * 0.8,height: 50)
        myProgressView.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.2)
        self.view.addSubview(myProgressView)
        
        
        // 建立一個 UIActivityIndicatorView
        myActivityIndicator = UIActivityIndicatorView(style:.whiteLarge)
        
        // 環狀進度條的顏色
        myActivityIndicator.color = UIColor.red
        
        // 底色
        myActivityIndicator.backgroundColor = UIColor.gray
        
        // 設置位置並放入畫面中
        myActivityIndicator.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.4)
        self.view.addSubview(myActivityIndicator);
    

        // 建立一個 UIButton
        myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        myButton.setTitle("Reset", for: .normal)
        myButton.backgroundColor = UIColor.blue
        myButton.addTarget(nil, action: #selector(ViewController.clickButton), for: .touchUpInside)
        myButton.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.65)
        self.view.addSubview(myButton)

        // 先執行一次進度條的動作
        self.clickButton()
    }

    @objc func clickButton() {
        // 進度推進時讓按鈕無法作用
        myButton.isEnabled = false
        
        // 分別重設兩個進度條
        myProgressView.progress = 0
        myActivityIndicator.startAnimating()
        
        // 建立一個 Timer
        myTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(ViewController.showProgress), userInfo: ["test":"for userInfo test"], repeats: true)
    }
    
    @objc func showProgress(_ sender: Timer) {
        // 以一個計數器模擬背景處理的動作
        count += 5
        
        // 每次都為進度條增加進度
        myProgressView.progress = Float(count) / Float(complete)

        // 進度完成時
        if count >= complete {
            // 示範 userInfo 傳入的參數
            let info = sender.userInfo as? Dictionary<String, AnyObject>
            print(info?["test"] ?? "")
            
            // 重設計數器及 Timer 供下次按下按鈕測試
            count = 0
            myTimer?.invalidate()
            myTimer = nil

            // 隱藏環狀進度條
            myActivityIndicator.stopAnimating()

            // 將按鈕功能啟動
            myButton.isEnabled = true
        }
    }

}

