//
//  AppDelegate.swift
//  Money
//
//  Created by joe feng on 2016/6/20.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 建立資料表
        let myUserDefaults = NSUserDefaults.standardUserDefaults()
        let dbInit = myUserDefaults.objectForKey("dbInit") as? Int
        if dbInit == nil {
            let dbFileName = "sqlite3.db"
            let db = SQLiteConnect(file: dbFileName)
            if let myDB = db {
                let result = myDB.createTable("records", columnsInfo: [
                    "id integer primary key autoincrement",
                    "title text",
                    "amount double",
                    "yearMonth text",
                    "createDate text",
                    "createTime DateTime"
                ])
                
                if result {
                    myUserDefaults.setObject(1, forKey: "dbInit")
                    myUserDefaults.setObject(dbFileName, forKey: "dbFileName")
                    myUserDefaults.synchronize()
                }
            }
        }
        
        // 設定導覽列預設底色
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 1.0, green: 0.87, blue: 0.0, alpha: 1)
        
        // 設定導覽列預設按鈕顏色
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        
        // 設定 UITableViewCell 預設底色
        UITableViewCell.appearance().backgroundColor = UIColor.init(red: 0.03, green: 0.03, blue: 0.03, alpha: 1)

        // 建立一個 UIWindow
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // 設置底色
        self.window!.backgroundColor = UIColor.blackColor()
        
        // 設置根視圖控制器
        self.window!.rootViewController = UINavigationController(rootViewController: ViewController())
        
        // 將 UIWindow 設置為可見的
        self.window!.makeKeyAndVisible()
        
        return true
    }

}

