//
//  AppDelegate.swift
//  Money
//
//  Created by joe feng on 2018/11/9.
//  Copyright © 2018年 Feng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dbURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("db.sqlite")
        } catch {
            fatalError("Error getting db URL from document directory.")
        }
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 建立資料表
        let myUserDefaults = UserDefaults.standard
        let dbInit = myUserDefaults.object(forKey: "dbInit") as? Int
        if dbInit == nil {
            let db = SQLiteConnect(path: dbURL.path)
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
                    myUserDefaults.set(1, forKey: "dbInit")
                    myUserDefaults.synchronize()
                }
            }
        }
        
        // 設定導覽列預設底色
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 1.0, green: 0.87, blue: 0.0, alpha: 1)
        
        // 設定導覽列預設按鈕顏色
        UINavigationBar.appearance().tintColor = UIColor.black
        
        // 設定 UITableViewCell 預設底色
        UITableViewCell.appearance().backgroundColor = UIColor.init(red: 0.03, green: 0.03, blue: 0.03, alpha: 1)
        
        // 建立一個 UIWindow
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // 設置底色
        self.window!.backgroundColor = UIColor.black
        
        // 設置根視圖控制器
        self.window!.rootViewController = UINavigationController(rootViewController: ViewController())
        
        // 將 UIWindow 設置為可見的
        self.window!.makeKeyAndVisible()

        return true
    }

}

