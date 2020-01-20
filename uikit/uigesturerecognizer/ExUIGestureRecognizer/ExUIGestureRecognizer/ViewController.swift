//
//  ViewController.swift
//  ExUIGestureRecognizer
//
//  Created by joe feng on 2016/5/25.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 取得螢幕的尺寸
    var fullSize = UIScreen.main.bounds.size

    var myUIView :UIView!
    var anotherUIView :UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        /************
         
         Tap 輕點手勢
         
         ************/
        
        // 雙指輕點 (雙指以上手勢只能用實機測試)
        let doubleFingers = UITapGestureRecognizer(target:self,action:#selector(ViewController.doubleTap(_:)))

        // 點幾下才觸發 設置 1 時 則是要點一下才會觸發 依此類推
        doubleFingers.numberOfTapsRequired = 1
        
        // 幾根指頭觸發
        doubleFingers.numberOfTouchesRequired = 2

        // 為視圖加入監聽手勢
        self.view.addGestureRecognizer(doubleFingers)

        
        // 單指輕點
        let singleFinger = UITapGestureRecognizer(target:self,action:#selector(ViewController.singleTap(_:)))

        // 點幾下才觸發 設置 2 時 則是要點兩下才會觸發 依此類推
        singleFinger.numberOfTapsRequired = 2
        
        // 幾根指頭觸發
        singleFinger.numberOfTouchesRequired = 1
        
        // 雙指輕點沒有觸發時 才會檢測此手勢 以免手勢被蓋過
        singleFinger.require(toFail: doubleFingers)
        
        // 為視圖加入監聽手勢
        self.view.addGestureRecognizer(singleFinger)

        
        /************
         
         Long Press 長按手勢
         
         ************/
        
        // 長按
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(_:)))
        
        // 為視圖加入監聽手勢
        self.view.addGestureRecognizer(longPress)

        
        /************
         
         Swipe 滑動手勢
         
         ************/
    
        // 一個可供移動的 UIView
        myUIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        myUIView.backgroundColor = UIColor.blue
        self.view.addSubview(myUIView)

        // 向上滑動
        let swipeUp = UISwipeGestureRecognizer(target:self, action:#selector(ViewController.swipe(_:)))
        swipeUp.direction = .up
        
        // 幾根指頭觸發 預設為 1
        swipeUp.numberOfTouchesRequired = 1

        // 為視圖加入監聽手勢
        self.view.addGestureRecognizer(swipeUp)
        
        
        // 向左滑動
        let swipeLeft = UISwipeGestureRecognizer(target:self, action:#selector(ViewController.swipe(_:)))
        swipeLeft.direction = .left
        
        // 為視圖加入監聽手勢
        self.view.addGestureRecognizer(swipeLeft)

        
        // 向下滑動
        let swipeDown = UISwipeGestureRecognizer(target:self, action:#selector(ViewController.swipe(_:)))
        swipeDown.direction = .down
        
        // 為視圖加入監聽手勢
        self.view.addGestureRecognizer(swipeDown)

        
        // 向右滑動
        let swipeRight = UISwipeGestureRecognizer(target:self, action:#selector(ViewController.swipe(_:)))
        swipeRight.direction = .right

        // 為視圖加入監聽手勢
        self.view.addGestureRecognizer(swipeRight)
        
        
        /************
         
         Pan 拖曳手勢
         
         ************/
        
        // 一個可供移動的 UIView
        anotherUIView = UIView(frame: CGRect(x: fullSize.width * 0.5, y: fullSize.height * 0.5, width: 100, height: 100))
        anotherUIView.backgroundColor = UIColor.orange
        self.view.addSubview(anotherUIView)
        
        // 拖曳手勢
        let pan = UIPanGestureRecognizer(target:self,action:#selector(ViewController.pan(_:)))
        
        // 最少可以用幾指拖曳
        pan.minimumNumberOfTouches = 1
        
        // 最多可以用幾指拖曳
        pan.maximumNumberOfTouches = 1
        
        // 為這個可移動的 UIView 加上監聽手勢
        anotherUIView.addGestureRecognizer(pan)
        
    }
    
    // 觸發拖曳手勢後 執行的動作
    @objc func pan(_ recognizer:UIPanGestureRecognizer) {
        // 設置 UIView 新的位置
        let point = recognizer.location(in: self.view)
        anotherUIView.center = point
    }

    // 觸發滑動手勢後 執行的動作
    @objc func swipe(_ recognizer:UISwipeGestureRecognizer) {
        let point = myUIView.center

        if recognizer.direction == .up {
            print("Go Up")
            if point.y >= 150 {
                myUIView.center = CGPoint(x: myUIView.center.x, y: myUIView.center.y - 100)
            } else {
                myUIView.center = CGPoint(x: myUIView.center.x, y: 50)
            }
        } else if recognizer.direction == .left {
            print("Go Left")
            if point.x >= 150 {
                myUIView.center = CGPoint(x: myUIView.center.x - 100, y: myUIView.center.y)
            } else {
                myUIView.center = CGPoint(x: 50, y: myUIView.center.y)
            }
        } else if recognizer.direction == .down {
            print("Go Down")
            if point.y <= fullSize.height - 150 {
                myUIView.center = CGPoint(x: myUIView.center.x, y: myUIView.center.y + 100)
            } else {
                myUIView.center = CGPoint(x: myUIView.center.x, y: fullSize.height - 50)
            }
        } else if recognizer.direction == .right {
            print("Go Right")
            if point.x <= fullSize.width - 150 {
                myUIView.center = CGPoint(x: myUIView.center.x + 100, y: myUIView.center.y)
            } else {
                myUIView.center = CGPoint(x: fullSize.width - 50, y: myUIView.center.y)
            }
        }
    }
    
    // 觸發長按手勢後 執行的動作
    @objc func longPress(_ recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            print("長按開始")
        } else if recognizer.state == .ended {
            print("長按結束")
        }
        
    }

    // 觸發單指輕點兩下手勢後 執行的動作
    @objc func singleTap(_ recognizer:UITapGestureRecognizer){
        print("單指連點兩下時觸發")
        
        // 取得每指的位置
        self.findFingersPositon(recognizer)
    }
    
    // 觸發雙指輕點一下手勢後 執行的動作
    @objc func doubleTap(_ recognizer:UITapGestureRecognizer){
        print("雙指點一下時觸發")

        // 取得每指的位置
        self.findFingersPositon(recognizer)
    }
    
    func findFingersPositon(_ recognizer:UITapGestureRecognizer) {
        // 取得每指的位置
        let number = recognizer.numberOfTouches
        for i in 0..<number {
            let point = recognizer.location(ofTouch: i, in: recognizer.view)
            print("第 \(i + 1) 指的位置：\(NSCoder.string(for: point))")
        }
    }

}

