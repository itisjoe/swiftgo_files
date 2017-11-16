//
//  ViewController.swift
//  ExImageUIGestureRecognizer
//
//  Created by joe feng on 2016/5/25.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 取得螢幕的尺寸
    var fullSize = UIScreen.main.bounds.size

    var myImageView :UIImageView!
    var anotherImageView :UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        /************
         
         Pinch 縮放手勢
         
         ************/
    
        // 建立一個用來縮放的圖片
        myImageView = UIImageView(image: UIImage(named: "01.jpg"))
        myImageView.frame = CGRect(x: 50, y: 50, width: 200, height: 200)
        self.view.addSubview(myImageView)
        
        let pinch = UIPinchGestureRecognizer(target:self,action:#selector(ViewController.pinch(_:)))

        self.view.addGestureRecognizer(pinch)
        

        /************
         
         Rotation 旋轉手勢
         
         ************/
        
        // 建立一個用來旋轉的圖片
        anotherImageView = UIImageView(image: UIImage(named: "02.jpg"))
        anotherImageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        anotherImageView.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.75)
        self.view.addSubview(anotherImageView)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(ViewController.rotation(_:)))

        self.view.addGestureRecognizer(rotation)

    }

    // 觸發旋轉手勢後 執行的動作
    @objc func rotation(_ recognizer:UIRotationGestureRecognizer) {
        // 弧度
        let radian = recognizer.rotation
        
        // 旋轉的弧度轉換為角度
        let angle = radian * (180 / CGFloat(Double.pi))

        anotherImageView.transform = CGAffineTransform(rotationAngle: radian)
        
        print("旋轉角度： \(angle)")
    }
    
    // 觸發縮放手勢後 執行的動作
    @objc func pinch(_ recognizer:UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            print("開始縮放")
        } else if recognizer.state == .changed {
            // 圖片原尺寸
            let frm = myImageView.frame
            
            // 縮放比例
            let scale = recognizer.scale
            
            // 目前圖片寬度
            let w = frm.width
            
            // 目前圖片高度
            let h = frm.height
            
            // 縮放比例的限制為 0.5 ~ 2 倍
            if w * scale > 100 && w * scale < 400 {
                myImageView.frame = CGRect(x: frm.origin.x, y: frm.origin.y, width: w * scale, height: h * scale)
            }
        } else if recognizer.state == .ended {
            print("結束縮放")
        }
        
    }

}

