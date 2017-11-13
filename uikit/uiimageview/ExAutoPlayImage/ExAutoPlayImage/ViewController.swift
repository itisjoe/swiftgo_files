//
//  ViewController.swift
//  ExAutoPlayImage
//
//  Created by joe feng on 2016/5/17.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 取得螢幕的尺寸
    let fullScreenSize = UIScreen.main.bounds.size

    var myImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        // 建立一個陣列 用來放置要輪播的圖片
        let imgArr = [UIImage(named:"01.jpg")!,UIImage(named:"02.jpg")!,UIImage(named:"03.jpg")!]
        
        // 設置要輪播的圖片陣列
        myImageView.animationImages = imgArr
        
        // 輪播一次的總秒數
        myImageView.animationDuration = 6
        
        // 要輪播幾次 (設置 0 則為無限次)
        myImageView.animationRepeatCount = 0
        
        // 開始輪播
        myImageView.startAnimating()
        
        // 設置位置及放入畫面中
        myImageView.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.4)
        self.view.addSubview(myImageView)
        
        // 建立一個播放按鈕
        let playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        
        // 設置播放按鈕的圖片
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
        // 設置按下播放按鈕的動作的方法
        playButton.addTarget(self, action: #selector(ViewController.play), for: .touchUpInside)
        
        // 設置位置及放入畫面中
        playButton.center = CGPoint(x: fullScreenSize.width * 0.35, y: fullScreenSize.height * 0.65)
        self.view.addSubview(playButton)

        // 建立一個停止按鈕
        let stopButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        
        // 設置停止按鈕的圖片
        stopButton.setImage(UIImage(named: "stop"), for: .normal)
        
        // 設置按下停止按鈕的動作的方法
        stopButton.addTarget(self, action: #selector(ViewController.stop), for: .touchUpInside)
        
        // 設置位置及放入畫面中
        stopButton.center = CGPoint(x: fullScreenSize.width * 0.65, y: fullScreenSize.height * 0.65)
        self.view.addSubview(stopButton)
        
    }
    
    @objc func play() {
        print("play images auto play")
        myImageView.startAnimating()
    }
    
    @objc func stop() {
        print("stop images auto play")
        myImageView.stopAnimating()
    }

}

