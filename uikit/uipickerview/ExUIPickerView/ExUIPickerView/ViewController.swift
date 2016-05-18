//
//  ViewController.swift
//  ExUIPickerView
//
//  Created by joe feng on 2016/5/18.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 取得螢幕的尺寸
        let fullScreenSize = UIScreen.mainScreen().bounds.size

        // 建立 UIPickerView 設置位置及尺寸
        let myPickerView = UIPickerView(frame: CGRect(x: 0, y: fullScreenSize.height * 0.3, width: fullScreenSize.width, height: 150))
        
        // 新增另一個 UIViewController
        // 用來實作委任模式的方法
        let myViewController = MyViewController()
        
        // 必須將這個 UIViewController 加入
        self.addChildViewController(myViewController)
        
        // 設定 UIPickerView 的 delegate 及 dataSource
        myPickerView.delegate = myViewController
        myPickerView.dataSource = myViewController
        
        // 加入到畫面
        self.view.addSubview(myPickerView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

