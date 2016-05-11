//
//  ViewController.swift
//  MyFirstProject
//
//  Created by joe feng on 2016/5/11.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        self.view.addSubview(firstView)

        let fullScreenSize = UIScreen.mainScreen().bounds.size

        firstView.center = CGPoint(x: fullScreenSize.width * 0.5 , y: fullScreenSize.height * 0.5)

        firstView.backgroundColor = UIColor.blueColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

