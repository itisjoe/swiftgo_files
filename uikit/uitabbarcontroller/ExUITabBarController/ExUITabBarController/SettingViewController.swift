//
//  SettingViewController.swift
//  ExUITabBarController
//
//  Created by joe feng on 2016/5/25.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 取得螢幕的尺寸
        let fullSize = UIScreen.mainScreen().bounds.size
        
        // 建立一個 UILabel
        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        myLabel.backgroundColor = UIColor.lightGrayColor()
        myLabel.text = "Setting 設定頁"
        myLabel.textAlignment = .Center
        myLabel.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.2)
        self.view.addSubview(myLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
