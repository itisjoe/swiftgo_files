//
//  ViewController.swift
//  ExAnimations
//
//  Created by joe feng on 2016/5/26.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var fullSize: CGSize!
    var myLabel: UILabel!

    let arrBounds = [CGSizeMake(100, 100), CGSizeMake(50, 50), CGSizeMake(150, 150), CGSizeMake(50, 50)]
    var arrCenter :[CGPoint]!
    let arrAlpha = [0.25, 0.75, 0.5, 1.0]
    let arrBackgroundColor = [UIColor.cyanColor(), UIColor.greenColor(), UIColor.orangeColor(), UIColor.blackColor()]
    let arrTransform = [CGAffineTransformMakeRotation(CGFloat(M_PI * 0.25)), CGAffineTransformMakeRotation(CGFloat(M_PI * 1.25)), CGAffineTransformMakeRotation(CGFloat(M_PI * 1.75)), CGAffineTransformMakeRotation(CGFloat(M_PI * 2))]

    var indexBounds = 0
    var indexCenter = 0
    var indexAlpha = 0
    var indexBackgroundColor = 0
    var indexTransform = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 取得螢幕的尺寸
        fullSize = UIScreen.mainScreen().bounds.size
        
        arrCenter = [
            CGPoint(x: fullSize.width * 0.75, y: fullSize.width * 0.25),
            CGPoint(x: fullSize.width * 0.75, y: fullSize.width * 0.75),
            CGPoint(x: fullSize.width * 0.25, y: fullSize.width * 0.75),
            CGPoint(x: fullSize.width * 0.25, y: fullSize.width * 0.25)]
        
        // 建立 UIButton 與 UILabel
        self.createButtonsAndLabel()

    }
    
    func createButtonsAndLabel() {
        // 建立一個 UILabel
        myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        myLabel.text = "Swift"
        myLabel.backgroundColor = UIColor.blackColor()
        myLabel.textColor = UIColor.whiteColor()
        myLabel.textAlignment = .Center
        myLabel.center = CGPoint(x: fullSize.width * 0.25, y: fullSize.width * 0.25)
        self.view.addSubview(myLabel)
        
        // 建立六個 UIButton
        let btnHeight = CGFloat(80.0)
        var btn = UIButton(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.5, height: btnHeight))
        btn.setTitle("bounds", forState: .Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        btn.addTarget(nil, action: #selector(ViewController.AnimateBounds), forControlEvents: .TouchUpInside)
        btn.center = CGPoint(x: fullSize.width * 0.25, y: fullSize.height - 2.5 * btnHeight)
        self.view.addSubview(btn)

        btn = UIButton(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.5, height: btnHeight))
        btn.setTitle("alpha", forState: .Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        btn.addTarget(nil, action: #selector(ViewController.AnimateAlpha), forControlEvents: .TouchUpInside)
        btn.center = CGPoint(x: fullSize.width * 0.75, y: fullSize.height - 2.5 * btnHeight)
        self.view.addSubview(btn)

        btn = UIButton(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.5, height: btnHeight))
        btn.setTitle("backgroundColor", forState: .Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        btn.addTarget(nil, action: #selector(ViewController.AnimateBackgroundColor), forControlEvents: .TouchUpInside)
        btn.center = CGPoint(x: fullSize.width * 0.25, y: fullSize.height - 1.5 * btnHeight)
        self.view.addSubview(btn)

        btn = UIButton(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.5, height: btnHeight))
        btn.setTitle("center", forState: .Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        btn.addTarget(nil, action: #selector(ViewController.AnimateCenter), forControlEvents: .TouchUpInside)
        btn.center = CGPoint(x: fullSize.width * 0.75, y: fullSize.height - 1.5 * btnHeight)
        self.view.addSubview(btn)
        
        btn = UIButton(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.5, height: btnHeight))
        btn.setTitle("transform", forState: .Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        btn.addTarget(nil, action: #selector(ViewController.AnimateTransForm), forControlEvents: .TouchUpInside)
        btn.center = CGPoint(x: fullSize.width * 0.25, y: fullSize.height - 0.5 * btnHeight)
        self.view.addSubview(btn)
        
        btn = UIButton(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.5, height: btnHeight))
        btn.setTitle("all", forState: .Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        btn.addTarget(nil, action: #selector(ViewController.AnimateAll), forControlEvents: .TouchUpInside)
        btn.center = CGPoint(x: fullSize.width * 0.75, y: fullSize.height - 0.5 * btnHeight)
        self.view.addSubview(btn)

    }
    
    func AnimateBounds() {
        let newSize = self.arrBounds[self.indexBounds]
        let originCenter = self.myLabel.center
        UIView.animateWithDuration(0.5, animations: {
            self.myLabel.bounds = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            self.myLabel.center = originCenter
        })
        self.updateIndex("bounds")
    }
    
    func AnimateAlpha() {
        UIView.animateWithDuration(0.5, animations: {
            self.myLabel.alpha = CGFloat(self.arrAlpha[self.indexAlpha])
        }, completion: { _ in
            print("Animation Alpha Complete")
        })
        
        self.updateIndex("alpha")
    }
    
    func AnimateBackgroundColor() {
        UIView.animateWithDuration(1, delay: 0.2, options: .CurveEaseIn, animations: {
            self.myLabel.backgroundColor = self.arrBackgroundColor[self.indexBackgroundColor]
            }, completion: { _ in
                print("Animation BackgroundColor Complete")
        })
        self.updateIndex("backgroundColor")
    }
    
    func AnimateCenter() {
        UIView.animateWithDuration(1.5, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                self.myLabel.center = self.arrCenter[self.indexCenter]
            }, completion: { _ in
                print("Animation Center Complete")
            })
        self.updateIndex("center")
    }
    
    func AnimateTransForm() {
        UIView.animateWithDuration(0.5, animations: {
            self.myLabel.transform = self.arrTransform[self.indexTransform]
        })
        self.updateIndex("transform")
    }
    
    func AnimateAll() {
        let newSize = self.arrBounds[self.indexBounds]
        UIView.animateWithDuration(0.5, animations: {
            self.myLabel.bounds = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            self.myLabel.alpha = CGFloat(self.arrAlpha[self.indexAlpha])
            self.myLabel.backgroundColor = self.arrBackgroundColor[self.indexBackgroundColor]
            self.myLabel.center = self.arrCenter[self.indexCenter]
            self.myLabel.transform = self.arrTransform[self.indexTransform]
        })
        self.updateIndex("all")
    }
    
    func updateIndex(type: String) {
        if type == "bounds" {
            self.indexBounds = self.indexBounds >= 3 ? 0 : self.indexBounds + 1
        } else if type == "alpha" {
            self.indexAlpha = self.indexAlpha >= 3 ? 0 : self.indexAlpha + 1
        } else if type == "backgroundColor" {
            self.indexBackgroundColor = self.indexBackgroundColor >= 3 ? 0 : self.indexBackgroundColor + 1
        } else if type == "center" {
            self.indexCenter = self.indexCenter >= 3 ? 0 : self.indexCenter + 1
        } else if type == "transform" {
            self.indexTransform = self.indexTransform >= 3 ? 0 : self.indexTransform + 1
        } else if type == "all" {
            self.indexBounds = self.indexBounds >= 3 ? 0 : self.indexBounds + 1
            self.indexCenter = self.indexCenter >= 3 ? 0 : self.indexCenter + 1
            self.indexAlpha = self.indexAlpha >= 3 ? 0 : self.indexAlpha + 1
            self.indexBackgroundColor = self.indexBackgroundColor >= 3 ? 0 : self.indexBackgroundColor + 1
            self.indexTransform = self.indexTransform >= 3 ? 0 : self.indexTransform + 1
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

