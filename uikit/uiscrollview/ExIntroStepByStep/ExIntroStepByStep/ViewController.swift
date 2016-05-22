//
//  ViewController.swift
//  ExIntroStepByStep
//
//  Created by joe feng on 2016/5/22.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    var myScrollview: UIScrollView!
    var pageControl: UIPageControl!
    var fullSize :CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 取得螢幕的尺寸
        fullSize = UIScreen.mainScreen().bounds.size
        
        // 建立 UIScrollView
        myScrollview = UIScrollView()
        
        // 設置尺寸 也就是可見視圖範圍
        myScrollview.frame = CGRect(x: 0, y: 20, width: fullSize.width, height: fullSize.height - 20)
        
        // 實際視圖範圍
        myScrollview.contentSize = CGSize(width: fullSize.width * 5, height: fullSize.height - 20)
        
        // 是否顯示滑動條
        myScrollview.showsHorizontalScrollIndicator = false
        myScrollview.showsVerticalScrollIndicator = false
        
        // 滑動超過範圍時是否使用彈回效果
        myScrollview.bounces = true
        
        // 設置委任對象
        myScrollview.delegate = self

        // 以一頁為單位滑動
        myScrollview.pagingEnabled = true
        
        // 加入到畫面中
        self.view.addSubview(myScrollview)


        // 建立 UIPageControl 設置位置及尺寸
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.85, height: 50))
        pageControl.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.85)
        
        // 有幾頁 就是有幾個點點
        pageControl.numberOfPages = 5
        
        // 起始預設的頁數
        pageControl.currentPage = 0
        
        // 目前所在頁數的點點顏色
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        
        // 其餘頁數的點點顏色
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        
        // 增加一個值改變時的事件
        pageControl.addTarget(self, action: #selector(ViewController.pageChanged), forControlEvents: .ValueChanged)
        
        // 加入到基底的視圖中 (不是加到 UIScrollView 裡)
        // 因為比較後面加入 所以會蓋在 UIScrollView 上面
        self.view.addSubview(pageControl)
        
        
        // 建立 5 個 UILabel 來顯示每個頁面內容
        var myLabel = UILabel()
        for i in 0...4 {
            myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: 40))
            myLabel.center = CGPoint(x: fullSize.width * (0.5 + CGFloat(i)), y: fullSize.height * 0.2)
            myLabel.font = UIFont(name: "Helvetica-Light", size: 48.0)
            myLabel.textAlignment = .Center
            myLabel.text = "\(i + 1)"
            myScrollview.addSubview(myLabel)
        }
        
    }
    
    // 滑動結束時
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 左右滑動到新頁時 更新 UIPageControl 顯示的頁數
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
    }
    
    // 點擊點點換頁
    func pageChanged(sender: UIPageControl) {
        // 依照目前圓點在的頁數算出位置
        var frame = myScrollview.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        
        // 再將 UIScrollView 滑動到該點
        myScrollview.scrollRectToVisible(frame, animated:true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

