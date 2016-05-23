//
//  ViewController.swift
//  ExMultiPages
//
//  Created by joe feng on 2016/5/23.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        myLabel.text = "首頁"
        self.view.addSubview(myLabel)
        
        // 建立前往 Article 頁面的 UIButton
        var myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        myButton.setTitle("Article", forState: .Normal)
        myButton.backgroundColor = UIColor.lightGrayColor()
        myButton.addTarget(nil, action: #selector(ViewController.goArticle), forControlEvents: .TouchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.2)
        self.view.addSubview(myButton)

        // 建立前往 Intro 頁面的 UIButton
        myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        myButton.setTitle("Intro", forState: .Normal)
        myButton.backgroundColor = UIColor.lightGrayColor()
        myButton.addTarget(nil, action: #selector(ViewController.goIntro), forControlEvents: .TouchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.4)
        self.view.addSubview(myButton)
        
        print("viewDidLoad")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear")
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("viewDidDisappear")
    }
    
    func goArticle() {
        self.presentViewController(ArticleViewController(), animated: true, completion: nil)
    }
    
    func goIntro() {
        self.presentViewController(IntroViewController(), animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

