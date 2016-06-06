//
//  AppDelegate.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/6.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var myLocationManager: CLLocationManager!
    var myUserDefaults: NSUserDefaults!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 取得儲存的預設資料
        self.myUserDefaults = NSUserDefaults.standardUserDefaults()

        // 建立一個 CLLocationManager
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            // 取得定位服務授權
            myLocationManager.requestWhenInUseAuthorization()
            
            // 設定後的動作請至委任方法
            // func locationManager(
            //   manager: CLLocationManager,
            //   didChangeAuthorizationStatus status: CLAuthorizationStatus)
            // 設置
        } else if (CLLocationManager.authorizationStatus() == .Denied) {
            // 設置定位權限的紀錄
            self.myUserDefaults.setObject(false, forKey: "locationAuth")
            self.myUserDefaults.synchronize()

        } else if (CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) {
            // 設置定位權限的紀錄
            self.myUserDefaults.setObject(true, forKey: "locationAuth")
            self.myUserDefaults.synchronize()
        }
        
        
        
        // 建立一個 UIWindow
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // 建立 UITabBarController
        let myTabBar = UITabBarController()

        // 建立 住宿 頁面
        let hotelViewController = UINavigationController(rootViewController: HotelMainViewController())
        hotelViewController.tabBarItem = UITabBarItem(title: "住宿", image: UIImage(named: "hotel"), tag: 100)
        
        // 建立 景點 頁面
        let landmarkViewController = UINavigationController(rootViewController: LandmarkMainViewController())
        landmarkViewController.tabBarItem = UITabBarItem(title: "景點", image: UIImage(named: "landmark"), tag: 200)
        
        // 建立 公園 頁面
        let parkViewController = UINavigationController(rootViewController: ParkMainViewController())
        parkViewController.tabBarItem = UITabBarItem(title: "公園", image: UIImage(named: "park"), tag: 300)
     
        // 建立 設定 頁面
        let settingsViewController = UINavigationController(rootViewController: SettingsMainViewController())
        settingsViewController.tabBarItem = UITabBarItem(title: "設定", image: UIImage(named: "settings"), tag: 400)
        
        // 加入到 UITabBarController
        myTabBar.viewControllers = [hotelViewController, landmarkViewController, parkViewController, settingsViewController]
        
        // 設置根視圖控制器
        self.window!.rootViewController = myTabBar
        
        // 將 UIWindow 設置為可見的
        self.window!.makeKeyAndVisible()
        
        
        
//        let auth = myUserDefaults.objectForKey("locationAuth") as? Bool ?? true
//        if !auth {
//            // 提示可至[設定]中開啟權限
//            let alertController = UIAlertController( title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .Alert)
//            let okAction = UIAlertAction(title: "確認", style: .Default, handler:nil)
//            alertController.addAction(okAction)
//            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
//        }
        
        
        return true
    }

// MARK: CLLocationManagerDelegate Methods
    
    // 更改定位權限時執行
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.Denied) {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController( title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "確認", style: .Default, handler:nil)
            alertController.addAction(okAction)
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            
            // 設置定位權限的紀錄
            self.myUserDefaults.setObject(false, forKey: "locationAuth")
            self.myUserDefaults.synchronize()
        } else if (status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            // 設置定位權限的紀錄
            self.myUserDefaults.setObject(true, forKey: "locationAuth")
            self.myUserDefaults.synchronize()
        }
    }
    
}

