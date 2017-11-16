//
//  DisplayViewController.swift
//  ExUserDefaults
//
//  Created by joe feng on 2016/10/17.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController {
    // 取得螢幕的尺寸
    let fullSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 設置底色
        self.view.backgroundColor = UIColor.white
        
        // 取得儲存的預設資料
        let myUserDefaults = UserDefaults.standard
        
        // 顯示儲存資訊的 UILabel
        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: 40))
        myLabel.textColor = UIColor.brown
        myLabel.textAlignment = .center
        myLabel.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.25)
        
        if let info = myUserDefaults.object(forKey: "info") as? String {
            myLabel.text = info
        } else {
            myLabel.text = "尚未儲存資訊"
            myLabel.textColor = UIColor.red
        }
        
        self.view.addSubview(myLabel)
    }

}
