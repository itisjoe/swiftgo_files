//
//  ViewController.swift
//  ExUIImageView
//
//  Created by joe feng on 2016/5/17.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 取得螢幕的尺寸
    let fullScreenSize = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()

        // 使用 UIImageView(frame:) 建立一個 UIImageView
        var myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        // 使用 UIImage(named:) 放置圖片檔案
        myImageView.image = UIImage(named: "01.jpg")

        // 設置新的位置並放入畫面中
        myImageView.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.15)
        self.view.addSubview(myImageView)

        
        // 使用 UIImageView(image:) 建立一個 UIImageView
        myImageView = UIImageView(image: UIImage(named: "02.jpg"))
        
        // 設置原點及尺寸
        myImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // 設置新的位置並放入畫面中
        myImageView.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.35)
        self.view.addSubview(myImageView)
    
        
        // 使用 UIImageView(image:, highlightedImage:) 建立一個 UIImageView
        myImageView = UIImageView(image: UIImage(named: "02.jpg"), highlightedImage: UIImage(named: "03.jpg"))
        
        // 設置原點及尺寸
        myImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // 設置圖片 highlighted 狀態
        myImageView.isHighlighted = true
        
        // 設置新的位置並放入畫面中
        myImageView.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.55)
        self.view.addSubview(myImageView)
        

        // 建立一個 UIImageView
        myImageView = UIImageView(image: UIImage(named: "04.jpg"))
        myImageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        // 設置背景顏色
        myImageView.backgroundColor = UIColor.yellow
        
        // 設置圖片顯示模式
        myImageView.contentMode = .bottomLeft
        
        // 設置新的位置並放入畫面中
        myImageView.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.8)
        self.view.addSubview(myImageView)
        
    }

}

