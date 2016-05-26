//
//  DisplayViewController.swift
//  ExNSUserDefaults
//
//  Created by joe feng on 2016/5/26.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 取得螢幕的尺寸
        let fullSize = UIScreen.mainScreen().bounds.size
        
        // 設置底色
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 取得儲存的預設資料
        let myUserDefaults = NSUserDefaults.standardUserDefaults()
        
        // 顯示儲存資訊的 UILabel
        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: 40))
        myLabel.textColor = UIColor.brownColor()
        myLabel.textAlignment = .Center
        myLabel.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.25)
        
        if let info = myUserDefaults.objectForKey("info") as? String {
            myLabel.text = info
        } else {
            myLabel.text = "尚未儲存資訊"
            myLabel.textColor = UIColor.redColor()
        }
        
        self.view.addSubview(myLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
