//
//  ViewController.swift
//  ExUILabel
//
//  Created by joe feng on 2016/5/13.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 使用 UILabel(frame:) 建立一個 UILabel
        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
        
        // 文字內容
        myLabel.text = "Swift 起步走"
        
        // 文字顏色
        myLabel.textColor = UIColor.redColor()
        
        // 文字的字型與大小
        myLabel.font = UIFont(name: "Helvetica-Light", size: 20)

        // 可以再修改文字的大小
        myLabel.font = myLabel.font.fontWithSize(24)

        // 或是可以使用系統預設字型 並設定文字大小
        myLabel.font = UIFont.systemFontOfSize(36)

        // 設定文字位置 置左、置中或置右等等
        myLabel.textAlignment = NSTextAlignment.Right
        
        // 也可以簡寫成這樣
        myLabel.textAlignment = .Center
        
        // 文字行數
        myLabel.numberOfLines = 1
        
        // 文字過多時 過濾的方式
        myLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        // 陰影的顏色 如不設定則預設為沒有陰影
        myLabel.shadowColor = UIColor.blackColor()

        // 陰影的偏移量 需先設定陰影的顏色
        myLabel.shadowOffset = CGSize(width: 2, height: 2)

        // 可以單獨設置新的 x 或 y
        myLabel.bounds.origin.x = 50
        myLabel.bounds.origin.y = 100
        // 或是使用 CGPoint(x:,y:) 設置新的原點
        myLabel.bounds.origin = CGPoint(x: 60, y: 120)
        
        // 可以單獨設置新的 width 或 height
        myLabel.bounds.size.width = 200
        myLabel.bounds.size.height = 100
        // 或是使用 CGSize(width:,height:) 設置新的尺寸
        myLabel.bounds.size = CGSize(width: 250, height: 80)
        
        // 或是也可以一起設置新的原點及尺寸
        myLabel.bounds = CGRect(x: 60, y: 120, width: 250, height: 80)

        // 取得螢幕的尺寸
        let fullScreenSize = UIScreen.mainScreen().bounds.size
        
        // 設置於畫面的中心點
        myLabel.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.5)

        // UILabel 的背景顏色
        myLabel.backgroundColor = UIColor.orangeColor()
        
        // 加入到畫面中
        self.view.addSubview(myLabel)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

