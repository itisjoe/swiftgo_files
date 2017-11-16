//
//  ViewController.swift
//  ExAnimations
//
//  Created by joe feng on 2016/5/26.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 取得螢幕的尺寸
    var fullSize = UIScreen.main.bounds.size

    var myLabel: UILabel!

    let arrBounds = [CGSize(width: 100, height: 100), CGSize(width: 50, height: 50), CGSize(width: 150, height: 150), CGSize(width: 50, height: 50)]
    var arrCenter :[CGPoint]!
    let arrAlpha = [0.25, 0.75, 0.5, 1.0]
    let arrBackgroundColor = [UIColor.cyan, UIColor.green, UIColor.orange, UIColor.black]
    let arrTransform = [CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.25)), CGAffineTransform(rotationAngle: CGFloat(Double.pi * 1.25)), CGAffineTransform(rotationAngle: CGFloat(Double.pi * 1.75)), CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))]

    var indexBounds = 0
    var indexCenter = 0
    var indexAlpha = 0
    var indexBackgroundColor = 0
    var indexTransform = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        myLabel.backgroundColor = UIColor.black
        myLabel.textColor = UIColor.white
        myLabel.textAlignment = .center
        myLabel.center = CGPoint(x: fullSize.width * 0.25, y: fullSize.width * 0.25)
        self.view.addSubview(myLabel)
        
        // 建立六個 UIButton
        let btnHeight = CGFloat(80.0)
        var btn = UIButton(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.5, height: btnHeight))
        btn.setTitle("bounds", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(nil, action: #selector(ViewController.AnimateBounds), for: .touchUpInside)
        btn.center = CGPoint(x: fullSize.width * 0.25, y: fullSize.height - 2.5 * btnHeight)
        self.view.addSubview(btn)

        btn = UIButton(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.5, height: btnHeight))
        btn.setTitle("alpha", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(nil, action: #selector(ViewController.AnimateAlpha), for: .touchUpInside)
        btn.center = CGPoint(x: fullSize.width * 0.75, y: fullSize.height - 2.5 * btnHeight)
        self.view.addSubview(btn)

        btn = UIButton(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.5, height: btnHeight))
        btn.setTitle("backgroundColor", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(nil, action: #selector(ViewController.AnimateBackgroundColor), for: .touchUpInside)
        btn.center = CGPoint(x: fullSize.width * 0.25, y: fullSize.height - 1.5 * btnHeight)
        self.view.addSubview(btn)

        btn = UIButton(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.5, height: btnHeight))
        btn.setTitle("center", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(nil, action: #selector(ViewController.AnimateCenter), for: .touchUpInside)
        btn.center = CGPoint(x: fullSize.width * 0.75, y: fullSize.height - 1.5 * btnHeight)
        self.view.addSubview(btn)
        
        btn = UIButton(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.5, height: btnHeight))
        btn.setTitle("transform", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(nil, action: #selector(ViewController.AnimateTransform), for: .touchUpInside)
        btn.center = CGPoint(x: fullSize.width * 0.25, y: fullSize.height - 0.5 * btnHeight)
        self.view.addSubview(btn)
        
        btn = UIButton(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.5, height: btnHeight))
        btn.setTitle("all", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(nil, action: #selector(ViewController.AnimateAll), for: .touchUpInside)
        btn.center = CGPoint(x: fullSize.width * 0.75, y: fullSize.height - 0.5 * btnHeight)
        self.view.addSubview(btn)

    }

    @objc func AnimateBounds() {
        let newSize = self.arrBounds[self.indexBounds]
        let originCenter = self.myLabel.center
        UIView.animate(withDuration: 0.5, animations: {
            self.myLabel.bounds = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            self.myLabel.center = originCenter
        })
        self.updateIndex("bounds")
    }
    
    @objc func AnimateAlpha() {
        UIView.animate(withDuration: 0.5, animations: {
            self.myLabel.alpha = CGFloat(self.arrAlpha[self.indexAlpha])
        }, completion: { _ in
            print("Animation Alpha Complete")
        })
        
        self.updateIndex("alpha")
    }
    
    @objc func AnimateBackgroundColor() {
        UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseIn, animations: {
            self.myLabel.backgroundColor = self.arrBackgroundColor[self.indexBackgroundColor]
            }, completion: { _ in
                print("Animation BackgroundColor Complete")
        })
        self.updateIndex("backgroundColor")
    }
    
    @objc func AnimateCenter() {
        UIView.animate(withDuration: 1.5, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.myLabel.center = self.arrCenter[self.indexCenter]
            }, completion: { _ in
                print("Animation Center Complete")
            })
        self.updateIndex("center")
    }
    
    @objc func AnimateTransform() {
        UIView.animate(withDuration: 0.5, animations: {
            self.myLabel.transform = self.arrTransform[self.indexTransform]
        })
        self.updateIndex("transform")
    }
    
    @objc func AnimateAll() {
        let newSize = self.arrBounds[self.indexBounds]
        UIView.animate(withDuration: 0.5, animations: {
            self.myLabel.bounds = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            self.myLabel.alpha = CGFloat(self.arrAlpha[self.indexAlpha])
            self.myLabel.backgroundColor = self.arrBackgroundColor[self.indexBackgroundColor]
            self.myLabel.center = self.arrCenter[self.indexCenter]
            self.myLabel.transform = self.arrTransform[self.indexTransform]
        })
        self.updateIndex("all")
    }
    
    func updateIndex(_ type: String) {
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

}

