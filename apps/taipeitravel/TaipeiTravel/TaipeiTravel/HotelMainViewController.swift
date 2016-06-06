//
//  HotelMainViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/6.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import CoreLocation

class HotelMainViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    var fullSize :CGSize!
    var myUserDefaults :NSUserDefaults!
    var myLocationManager :CLLocationManager!
    var myActivityIndicator :UIActivityIndicatorView! = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
    var myTableView :UITableView!
    var todayDateInt :Int!
    var taipeiDataUrl :String!
    var documentsPath :String!
    var targetUrl :String!
    var strTargetID :String!
    var apiData :[AnyObject]!
    var apiDataForDistance :[Coordinate]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 取得螢幕的尺寸
        self.fullSize = UIScreen.mainScreen().bounds.size

        // 取得儲存的預設資料
        self.myUserDefaults = NSUserDefaults.standardUserDefaults()
        
        // 建立一個 CLLocationManager
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // 取得今天日期
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        self.todayDateInt = Int(dateFormatter.stringFromDate(NSDate()))!
        
        // 應用程式儲存檔案的目錄路徑
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        self.documentsPath = urls[urls.count-1].absoluteString
        
        self.taipeiDataUrl = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid="
        
        // 台北住宿資料 ID
        self.strTargetID = "6f4e0b9b-8cb1-4b1d-a5c4-febd90f62469" //&limit=3&offset=0"
        
        self.targetUrl = self.documentsPath + "hotel.json"
        
        // 導覽列
        self.addNav()
        
        // 取得 API 資料
        self.addData()

        // 載入中 環狀進度條
        myActivityIndicator.center = CGPoint(x: self.fullSize.width * 0.5, y: self.fullSize.height * 0.4)
        myActivityIndicator.startAnimating()
        myActivityIndicator.hidesWhenStopped = true
        self.view.addSubview(myActivityIndicator)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (CLLocationManager.authorizationStatus() == .Denied) {
            // 設置定位權限的紀錄
            self.myUserDefaults.setObject(false, forKey: "locationAuth")
            self.myUserDefaults.synchronize()
        } else if (CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) {
            // 設置定位權限的紀錄
            self.myUserDefaults.setObject(true, forKey: "locationAuth")
            self.myUserDefaults.synchronize()
            
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
        
        // 更新 table
        print("viewDidAppear reload table")
        if let table = self.myTableView {
            self.reloadAPIData()
            table.reloadData()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 停止定位自身位置
        myLocationManager.stopUpdatingLocation()
    }
    
    func addNav() {
        // 底色
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 導覽列標題
        self.title = "住宿"
        
        // 導覽列是否半透明
        self.navigationController?.navigationBar.translucent = false
    }
    
    func addData() {
        // 取得前一次取得資料的日期
        let hotelFetchDate = myUserDefaults.objectForKey("hotelFetchDate") as? Int

        // 如果尚未取得資料 或 前一次取得資料已經超過一天(兩天以上)
        // 便向遠端 API 取得資料
        let date = hotelFetchDate ?? 0
        if self.todayDateInt - date > 1 {
            //self.simpleGet(self.taipeiDataUrl + self.strTargetID, targetPath: self.documentsPath + "hotel.json")
            self.normalGet(self.taipeiDataUrl + self.strTargetID)
        } else {
            // 如果資料已在兩天內取得過 便直接建立 table
            self.addTable(self.documentsPath + "hotel.json")
        }

    }
    
    func addTable(file :String?) {
        
        if let filePath = file {
            if let fileurl = NSURL(string: filePath) {
                self.jsonParse(fileurl)
            }
        }

        // 建立 UITableView 並設置原點及尺寸
        self.myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.fullSize.width, height: self.fullSize.height - 113), style: .Plain)
        
        //self.myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // 設置委任對象
        self.myTableView.delegate = self
        self.myTableView.dataSource = self

        // 是否可以點選 cell
        self.myTableView.allowsSelection = true

        // 加入到畫面中
        self.view.addSubview(self.myTableView)

        // 隱藏環狀進度條
        myActivityIndicator.stopAnimating()
    }

    
// MARK: CLLocationManagerDelegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation :CLLocation = locations[0] as CLLocation

        // 更新自身定位座標
        self.myUserDefaults.setObject(currentLocation.coordinate.latitude, forKey: "userLatitude")
        self.myUserDefaults.setObject(currentLocation.coordinate.longitude, forKey: "userLongitude")
        self.myUserDefaults.synchronize()
        
        // 更新 table
        print("locationManager reload table")
        if let table = self.myTableView {
            self.reloadAPIData()
            table.reloadData()
        }
    }
    
    // 更改定位權限時執行
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.Denied) {
            // 設置定位權限的紀錄
            self.myUserDefaults.setObject(false, forKey: "locationAuth")
            self.myUserDefaults.synchronize()
        } else if (status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            // 設置定位權限的紀錄
            self.myUserDefaults.setObject(true, forKey: "locationAuth")
            self.myUserDefaults.synchronize()
            
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        } 
    }

// MARK: UITableViewDelegate methods
    
    // 必須實作的方法：有幾個 cell
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiData.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
        }

        // 設置 Accessory 按鈕樣式
        cell!.accessoryType = .DisclosureIndicator
        
        // 這筆資料
        let thisData = self.apiData[self.apiDataForDistance[indexPath.row].index]
        
        // 顯示的內容
        if let myLabel = cell!.textLabel {
            if let title = thisData["stitle"] {
                myLabel.text = title as? String
            }
        }
        
        // 距離
        cell!.detailTextLabel?.text = ""

        // 有定位權限
        let locationAuth = myUserDefaults.objectForKey("locationAuth") as? Bool
        if locationAuth != nil && locationAuth! {
            // 取得目前使用者座標
            let userLatitude = myUserDefaults.objectForKey("userLatitude") as? Double
            let userLongitude = myUserDefaults.objectForKey("userLongitude") as? Double
            let userLocation = CLLocation(latitude: userLatitude!, longitude: userLongitude!)
            
            // 這筆資料的座標
            var thisDataLatitude = 0.0
            if let num = thisData["latitude"] as? NSString {
                thisDataLatitude = num.doubleValue
            }
            
            var thisDataLongitude = 0.0
            if let num = thisData["longitude"] as? NSString {
                thisDataLongitude = num.doubleValue
            }
            if thisDataLatitude == 0.0 && thisDataLongitude == 0.0 {
                cell!.detailTextLabel?.text = ""
            } else {
                let thisDataLocation = CLLocation(latitude: thisDataLatitude, longitude: thisDataLongitude)
                
                let distance = Int(userLocation.distanceFromLocation(thisDataLocation))
                var detail = ""
                if distance > 20000 {
                    detail = "超過 20 KM"
                } else if distance > 1000 {
                    detail = "\(Int(distance / 1000)) KM"
                } else if distance > 100 {
                    detail = "\(Int(distance / 100))00 M"
                } else {
                    detail = "\(distance) M"
                }

                cell!.detailTextLabel?.text = detail
            }
        }
        
        return cell!
    }
    
    // 點選 cell 後執行的動作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let name = self.apiData[indexPath.row]["stitle"]
        print("選擇的是 \(name)")
    }
    
    // 點選 Accessory 按鈕後執行的動作
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let name = self.apiData[indexPath.row]["stitle"]
        print("按下的是 \(name) 的 detail")
    }

    
    // MARK: NSURLSessionDownloadDelegate Methods
    
    // 下載完成
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("下載完成")
        
        let targetUrl = NSURL(string: self.targetUrl)!
        let data = NSData(contentsOfURL: location)
        if ((data?.writeToURL(targetUrl, atomically: true)) != nil) {
            print("普通獲取遠端資訊的方式：儲存資訊成功")

            
            // 更新獲取資料的日期
            self.myUserDefaults.setObject(self.todayDateInt, forKey: "hotelFetchDate")
            self.myUserDefaults.synchronize()
            
            dispatch_async(dispatch_get_main_queue(), {
                self.addTable(self.targetUrl)
            })
            
        } else {
            print("普通獲取遠端資訊的方式：儲存資訊失敗")
            
        }
    }

    
    
    
// MARK: functional methods
    
    // 普通獲取遠端資訊的方式
    func normalGet(myUrl :String) {
        if let url = NSURL(string: myUrl) {
            // 設置為預設的 session 設定
            let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            // 設置委任對象
            let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: nil)
            
            // 設置遠端 API 網址
            let dataTask = session.downloadTaskWithURL(url)
            
            // 執行動作
            dataTask.resume()
        }
    }
    
    
    // 基本獲取遠端資訊的方式
    func simpleGet(myUrl :String, targetPath :String) {

        
        if let url = NSURL(string: myUrl) {

            
            
            
            NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
                
                // 建立檔案
                let fileurl = NSURL(string: targetPath)

                
                if let result = data?.writeToURL(fileurl!, atomically: true) {
                
                    
                    if result {
                        // 更新獲取資料的日期
                        self.myUserDefaults.setObject(self.todayDateInt, forKey: "hotelFetchDate")
                        self.myUserDefaults.synchronize()
                        
                        print("基本獲取遠端資訊的方式：儲存資訊成功")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.addTable(targetPath)
                        })
                    } else {
                        print("基本獲取遠端資訊的方式：儲存資訊失敗")
                    }

                
                }
 

                
            }.resume()

        
        
        }
    }

    // 解析 json 檔案
    func jsonParse(url :NSURL) {
        do {
            let dict = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: url)!, options: NSJSONReadingOptions.AllowFragments) as! [String:[String:AnyObject]]

            let dataArr = dict["result"]!["results"] as! [AnyObject]
            
            self.apiData = dataArr
            
            self.reloadAPIData()
            
        } catch {
            print("解析 json 失敗")
        }
        
    }
    
    func reloadAPIData() {
        if let allData = self.apiData {
            var index = 0
            
            self.apiDataForDistance = []
            
            for data in allData {
                
                var latitude = 0.0
                if let num = data["latitude"] as? NSString {
                    latitude = num.doubleValue
                }
                
                var longitude = 0.0
                if let num = data["longitude"] as? NSString {
                    longitude = num.doubleValue
                }
                
                let coordinate = Coordinate(
                    index: index ,
                    latitude: latitude ,
                    longitude: longitude )
                self.apiDataForDistance.append(coordinate)
                
                index += 1
            }
            self.apiDataForDistance.sortInPlace(<)
        }
    }
    
}
