//
//  ViewController.swift
//  ExUIButton
//
//  Created by joe feng on 2016/5/16.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 取得螢幕的尺寸
    let fullScreenSize = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()

        // 為基底的 self.view 設置底色
        self.view.backgroundColor = UIColor.white
        
        // 預設的按鈕樣式
        var myButton = UIButton(type: .contactAdd)
        myButton.center = CGPoint(x: fullScreenSize.width * 0.4, y: fullScreenSize.height * 0.2)
        self.view.addSubview(myButton)

        myButton = UIButton(type: .infoLight)
        myButton.center = CGPoint(x: fullScreenSize.width * 0.6, y: fullScreenSize.height * 0.2)
        self.view.addSubview(myButton)
        
        // 使用 UIButton(frame:) 建立一個 UIButton
        myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        // 按鈕文字
        myButton.setTitle("按我", for: .normal)
        
        // 按鈕文字顏色
        myButton.setTitleColor(UIColor.white, for: .normal)
        
        // 按鈕是否可以使用
        myButton.isEnabled = true
        
        // 按鈕背景顏色
        myButton.backgroundColor = UIColor.darkGray
        
        // 按鈕按下後的動作
        myButton.addTarget(nil, action: #selector(ViewController.clickButton), for: .touchUpInside)
        
        // 設置位置並加入畫面
        myButton.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.5)
        self.view.addSubview(myButton)
        
    }

    @objc func clickButton() {
        // 為基底的 self.view 的底色在黑色與白色兩者間切換
        if self.view.backgroundColor!.isEqual(UIColor.white) {
            self.view.backgroundColor = UIColor.black
        } else {
            self.view.backgroundColor = UIColor.white
        }
    }

}

