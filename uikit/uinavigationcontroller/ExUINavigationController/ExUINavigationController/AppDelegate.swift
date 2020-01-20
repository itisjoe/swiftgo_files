//
//  AppDelegate.swift
//  ExUINavigationController
//
//  Created by joe feng on 2016/5/24.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 建立一個 UIWindow
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // 設置底色
        self.window!.backgroundColor = UIColor.white
        
        // 設置根視圖控制器
        let nav = UINavigationController(rootViewController: ViewController())
        self.window!.rootViewController = nav
        
        // 將 UIWindow 設置為可見的
        self.window!.makeKeyAndVisible()
        
        return true
    }

}

