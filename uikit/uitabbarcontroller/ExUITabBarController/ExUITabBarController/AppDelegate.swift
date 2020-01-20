//
//  AppDelegate.swift
//  ExUITabBarController
//
//  Created by joe feng on 2016/5/25.
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
        
        // 建立 UITabBarController
        let myTabBar = UITabBarController()
        
        // 設置標籤列
        // 使用 UITabBarController 的屬性 tabBar 的各個屬性設置
        myTabBar.tabBar.backgroundColor = UIColor.clear
        
        // 建立頁面 使用系統圖示
        let mainViewController = ViewController()
        mainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 100)

        // 建立頁面 使用自定義圖示 有預設圖片及按下時圖片
        let articleViewController = ArticleViewController()
        articleViewController.tabBarItem = UITabBarItem(title: "文章", image: UIImage(named: "article"), selectedImage: UIImage(named: "articleSelected"))

        // 建立頁面 使用自定義圖示 只有預設圖片
        let introViewController = IntroViewController()
        introViewController.tabBarItem = UITabBarItem(title: "介紹", image: UIImage(named: "profile"), tag: 200)

        // 建立頁面 使用自定義圖示 可使用 tabBarItem 的屬性各自設定
        let settingViewController = SettingViewController()
        settingViewController.tabBarItem.image = UIImage(named: "setting")
        settingViewController.tabBarItem.title = "設定"

        // 加入到 UITabBarController
        myTabBar.viewControllers = [mainViewController, articleViewController, introViewController, settingViewController]

        // 預設開啟的頁面 (從 0 開始算起)
        myTabBar.selectedIndex = 2
        
        // 設置根視圖控制器
        self.window!.rootViewController = myTabBar
        
        // 將 UIWindow 設置為可見的
        self.window!.makeKeyAndVisible()
        
        return true
    }

}

