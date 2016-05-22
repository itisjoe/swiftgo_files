//
//  ViewController.swift
//  ExUIScrollView
//
//  Created by joe feng on 2016/5/22.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    var myScrollview: UIScrollView!
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
        myScrollview.contentSize = CGSize(width: fullSize.width * 3, height: fullSize.height * 2)
        
        // 是否顯示水平的滑動條
        myScrollview.showsHorizontalScrollIndicator = true
        
        // 是否顯示垂直的滑動條
        myScrollview.showsVerticalScrollIndicator = true
        
        // 滑動條的樣式
        myScrollview.indicatorStyle = .Black
        
        // 是否可以滑動
        myScrollview.scrollEnabled = true
        
        // 是否可以按狀態列回到最上方
        myScrollview.scrollsToTop = false
        
        // 限制滑動時只能單個方向 垂直或水平滑動
        myScrollview.directionalLockEnabled = false
        
        // 滑動超過範圍時是否使用彈回效果
        myScrollview.bounces = true
        
        // 縮放元件的預設縮放大小
        myScrollview.zoomScale = 1.0

        // 縮放元件可縮小到的最小倍數
        myScrollview.minimumZoomScale = 0.5
        
        // 縮放元件可放大到的最大倍數
        myScrollview.maximumZoomScale = 2.0

        // 縮放元件縮放時是否在超過縮放倍數後使用彈回效果
        myScrollview.bouncesZoom = true

        // 設置委任對象
        myScrollview.delegate = self

        // 起始的可見視圖偏移量 預設為 (0, 0)
        // 設定這個值後 就會將原點滑動至這個點起始
        myScrollview.contentOffset = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.5)
        
        // 以一頁為單位滑動
        myScrollview.pagingEnabled = false

        // 加入到畫面中
        self.view.addSubview(myScrollview)


        // 建立六個 UIView 來顯示出滑動的路徑
        var myUIView = UIView()
        for i in 0...2 {
            for j in 0...1 {
                myUIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                myUIView.tag = i * 10 + j + 1
                myUIView.center = CGPoint(x: fullSize.width * (0.5 + CGFloat(i)), y: fullSize.height * (0.5 + CGFloat(j)))
                let color = ((CGFloat(i) + 1) * (CGFloat(j) + 1)) / 12.0
                myUIView.backgroundColor = UIColor.init(red: color, green: color, blue: color, alpha: 1)
                myScrollview.addSubview(myUIView)
            }
        }
        
    }
    
    // 開始滑動時
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    
    // 滑動時
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //print("scrollViewDidScroll")
    }
    
    // 結束滑動時
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
    }
    
    // 縮放的元件
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        // 這邊用來示範縮放的元件是 tag 為 1 的 UIView
        // 也就是左上角那個 UIView
        return self.view.viewWithTag(1)
    }

    // 開始縮放時
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        print("scrollViewWillBeginZooming")
    }
    
    // 縮放時
    func scrollViewDidZoom(scrollView: UIScrollView) {
        //print("scrollViewDidZoom")
    }
    
    // 結束縮放時
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming")
        
        // 縮放元件時 會將 contentSize 設為這個元件的尺寸
        // 會導致 contentSize 過小而無法滑動
        // 所以縮放完後再將 contentSize 設回原本大小
        myScrollview.contentSize = CGSize(width: fullSize.width * 3, height: fullSize.height * 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

