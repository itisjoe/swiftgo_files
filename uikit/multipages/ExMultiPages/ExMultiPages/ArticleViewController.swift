//
//  ArticleViewController.swift
//  ExMultiPages
//
//  Created by joe feng on 2016/5/23.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 取得螢幕的尺寸
        let fullSize = UIScreen.mainScreen().bounds.size
        
        // 設置底色
        self.view.backgroundColor = UIColor.whiteColor()

        // 頁面標題
        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: 40))
        myLabel.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.08)
        myLabel.textAlignment = .Center
        myLabel.text = "Article 頁"
        self.view.addSubview(myLabel)
        
        // 建立前往 Detail 頁面的 UIButton
        var myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        myButton.setTitle("Detail", forState: .Normal)
        myButton.backgroundColor = UIColor.lightGrayColor()
        myButton.addTarget(nil, action: #selector(ArticleViewController.goDetail), forControlEvents: .TouchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.3)
        self.view.addSubview(myButton)
        
        // 返回主頁面的 UIButton
        myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        myButton.setTitle("回前頁", forState: .Normal)
        myButton.backgroundColor = UIColor.lightGrayColor()
        myButton.addTarget(nil, action: #selector(ArticleViewController.goBack), forControlEvents: .TouchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.5)
        self.view.addSubview(myButton)
    }
    
    func goDetail() {
        self.presentViewController(ArticleDetailViewController(), animated: true, completion: nil)
    }
    
    
    func goBack() {
        self.dismissViewControllerAnimated(true, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
