//
//  ViewController.swift
//  ExUIButton
//
//  Created by joe feng on 2016/5/16.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 取得螢幕的尺寸
        let fullScreenSize = UIScreen.mainScreen().bounds.size

        // 為基底的 self.view 設置底色
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 預設的按鈕樣式
        var myButton = UIButton(type: .ContactAdd)
        myButton.center = CGPoint(x: fullScreenSize.width * 0.4, y: fullScreenSize.height * 0.2)
        self.view.addSubview(myButton)

        myButton = UIButton(type: .InfoLight)
        myButton.center = CGPoint(x: fullScreenSize.width * 0.6, y: fullScreenSize.height * 0.2)
        self.view.addSubview(myButton)
        
        // 使用 UIButton(frame:) 建立一個 UIButton
        myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        // 按鈕文字
        myButton.setTitle("按我", forState: .Normal)
        
        // 按鈕文字顏色
        myButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        // 按鈕是否可以使用
        myButton.enabled = true
        
        // 按鈕背景顏色
        myButton.backgroundColor = UIColor.darkGrayColor()
        
        // 按鈕按下後的動作
        myButton.addTarget(nil, action: #selector(ViewController.clickButton), forControlEvents: .TouchUpInside)
        
        // 設置位置並加入畫面
        myButton.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.5)
        self.view.addSubview(myButton)
        
    }

    func clickButton() {
        // 為基底的 self.view 的底色在黑色與白色兩者間切換
        if self.view.backgroundColor!.isEqual(UIColor.whiteColor()) {
            self.view.backgroundColor = UIColor.blackColor()
        } else {
            self.view.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

