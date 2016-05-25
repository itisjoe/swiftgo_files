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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // 建立一個 UIWindow
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // 設置底色
        self.window!.backgroundColor = UIColor.whiteColor()
        
        // 建立 UITabBarController
        let myTabBar = UITabBarController()
        
        // 設置標籤列
        // 使用 UITabBarController 的屬性 tabBar 的各個屬性設置
        myTabBar.tabBar.backgroundColor = UIColor.clearColor()
        
        // 建立頁面 使用系統圖示
        let mainViewController = ViewController()
        mainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .Favorites, tag: 100)

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

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

