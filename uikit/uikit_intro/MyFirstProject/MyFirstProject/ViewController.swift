//
//  ViewController.swift
//  MyFirstProject
//
//  Created by joe feng on 2016/5/11.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 取得螢幕的尺寸
    let fullScreenSize = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()

        // 定義一個 UIView 的常數 名稱為 firstView
        let firstView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        // 將 firstView 加入到 self.view
        self.view.addSubview(firstView)

        // 設置 UIView 的位置到畫面的中心
        firstView.center = CGPoint(x: fullScreenSize.width * 0.5 , y: fullScreenSize.height * 0.5)

        // 將 UIView 的底色設置為藍色
        firstView.backgroundColor = UIColor.blue

    }

}

