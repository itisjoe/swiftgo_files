//
//  ArticleViewController.swift
//  ExMultiPages
//
//  Created by joe feng on 2016/5/23.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
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
        myLabel.text = "Article 頁"
        self.view.addSubview(myLabel)
        
        // 建立前往 Detail 頁面的 UIButton
        var myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        myButton.setTitle("Detail", for: .normal)
        myButton.backgroundColor = UIColor.lightGray
        myButton.addTarget(nil, action: #selector(ArticleViewController.goDetail), for: .touchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.3)
        self.view.addSubview(myButton)
        
        // 返回主頁面的 UIButton
        myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        myButton.setTitle("回前頁", for: .normal)
        myButton.backgroundColor = UIColor.lightGray
        myButton.addTarget(nil, action: #selector(ArticleViewController.goBack), for: .touchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.5)
        self.view.addSubview(myButton)
    }
    
    @objc func goDetail() {
        self.present(ArticleDetailViewController(), animated: true, completion: nil)
    }
    
    
    @objc func goBack() {
        self.dismiss(animated: true, completion:nil)
    }

}
