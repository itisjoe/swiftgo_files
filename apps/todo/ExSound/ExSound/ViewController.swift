//
//  ViewController.swift
//  ExSound
//
//  Created by joe feng on 2016/6/14.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var myPlayer :AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 建立播放器
        let soundPath = Bundle.main.path(forResource: "woohoo", ofType: "wav")
        do {
            myPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))

            // 重複播放次數 設為 0 則是只播放一次 不重複
            myPlayer.numberOfLoops = 0
        
        } catch {
            print("error")
        }


        // 建立一個按鈕
        let myButton = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 60))
        myButton.setTitle("音效", for: .normal)
        myButton.setTitleColor(UIColor.blue, for: .normal)
        myButton.addTarget(self, action: #selector(ViewController.go), for: .touchUpInside)
        self.view.addSubview(myButton)
    
    }

    func go() {
        // 播放音效
        myPlayer.play()
    }
    
}

