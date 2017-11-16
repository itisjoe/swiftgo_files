//
//  ArticleDetailViewController.swift
//  ExMultiPages
//
//  Created by joe feng on 2016/5/23.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    // 取得螢幕的尺寸
    let fullSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設置底色
        self.view.backgroundColor = UIColor.white
        
        // 頁面標題
        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: 40))
        myLabel.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.08)
        myLabel.textAlignment = .center
        myLabel.text = "Article Detail 頁"
        self.view.addSubview(myLabel)

        // 返回 Article 頁的 UIButton
        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        myButton.setTitle("回前頁", for: .normal)
        myButton.backgroundColor = UIColor.lightGray
        myButton.addTarget(nil, action: #selector(ArticleDetailViewController.goBack), for: .touchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.5)
        self.view.addSubview(myButton)
    }

    @objc func goBack() {
        self.dismiss(animated: true, completion:nil)
    }

}
