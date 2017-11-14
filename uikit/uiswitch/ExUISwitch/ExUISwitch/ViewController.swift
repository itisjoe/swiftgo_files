//
//  ViewController.swift
//  ExUISwitch
//
//  Created by joe feng on 2016/5/18.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 取得螢幕的尺寸
    let fullScreenSize = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 建立一個 UISwitch
        var mySwitch = UISwitch()
        
        // 設置位置並放入畫面中
        mySwitch.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.3)
        self.view.addSubview(mySwitch)
        
        
        // 建立另一個 UISwitch
        mySwitch = UISwitch()
        
        // 設置滑桿鈕的顏色
        mySwitch.thumbTintColor = UIColor.orange
        
        // 設置未選取時( off )的外觀顏色
        mySwitch.tintColor = UIColor.blue
        
        // 設置選取時( on )的外觀顏色
        mySwitch.onTintColor = UIColor.brown
        
        // 設置切換 UISwitch 時執行的動作
        mySwitch.addTarget(self, action: #selector(ViewController.onChange), for: .valueChanged)
        
        // 設置位置並放入畫面中
        mySwitch.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.5)
        self.view.addSubview(mySwitch)
        
    }
    
    // UISwitch 切換時 執行動作的方法
    @objc func onChange(_ sender: AnyObject) {
        // 取得這個 UISwtich 元件
        let tempSwitch = sender as! UISwitch
        
        // 依據屬性 isOn 來為底色變色
        if tempSwitch.isOn {
            self.view.backgroundColor = UIColor.black
        } else {
            self.view.backgroundColor = UIColor.white
        }
    }

}

