//
//  BaseMainViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/6.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import CoreLocation

class BaseMainViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, URLSessionDelegate, URLSessionDownloadDelegate {
    var fullSize :CGSize!
    var myUserDefaults :UserDefaults!
    var myLocationManager :CLLocationManager!
    var fetchType :String!
    let refreshDays :Int = 5
    var myActivityIndicator :UIActivityIndicatorView!
    var myTableView :UITableView!
    var todayDateInt :Int!
    var taipeiDataUrl :String!
    var targetUrl :URL!
    var strTargetID :String!
    var apiDataAll :[AnyObject]!
    var apiData :[AnyObject]!
    var apiDataForDistance :[Coordinate]!

    // 超過多少距離才重新取得有限數量資料 (公尺)
    let limitDistance = 500.0
    
    // 有限數量資料的個數
    let limitNumber = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 取得螢幕的尺寸
        self.fullSize = UIScreen.main.bounds.size
        
        // 取得儲存的預設資料
        self.myUserDefaults = UserDefaults.standard
        
        // 導覽列樣式
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
        // 建立一個 CLLocationManager
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // 取得今天日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        self.todayDateInt = Int(dateFormatter.string(from: Date()))!

        self.taipeiDataUrl = "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid="
        
        // 載入中 環狀進度條
        myActivityIndicator = UIActivityIndicatorView(style:.gray)
        myActivityIndicator.center = CGPoint(x: self.fullSize.width * 0.5, y: self.fullSize.height * 0.4)
        myActivityIndicator.startAnimating()
        myActivityIndicator.hidesWhenStopped = true
        self.view.addSubview(myActivityIndicator)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (CLLocationManager.authorizationStatus() == .denied) {
            // 設置定位權限的紀錄
            self.myUserDefaults.set(false, forKey: "locationAuth")
            self.myUserDefaults.synchronize()
        } else if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            // 設置定位權限的紀錄
            self.myUserDefaults.set(true, forKey: "locationAuth")
            self.myUserDefaults.synchronize()
            
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
        
        // 更新 table
        if let table = self.myTableView {
            myActivityIndicator.startAnimating()

            self.refreshAPIData()
            table.reloadData()

            myActivityIndicator.stopAnimating()

        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 停止定位自身位置
        myLocationManager.stopUpdatingLocation()
    }
    
    func addData() {
        // 取得前一次取得資料的日期
        let fetchDate = myUserDefaults.object(forKey: self.fetchType + "FetchDate") as? Int
        
        // 如果尚未取得資料 或 前一次取得資料已經超過設定天數
        // 便向遠端 API 取得資料
        let date = fetchDate ?? 0
        if self.todayDateInt - date > self.refreshDays {
            self.normalGet(self.taipeiDataUrl + self.strTargetID)
        } else {
            // 如果資料已在設定天數內取得過 便直接建立 table
            self.addTable(self.targetUrl)
        }
        
    }
    
    func addTable(_ filePath :URL?) {
        if let path = filePath {
            self.jsonParse(path)
        }
        
        // 建立 UITableView 並設置原點及尺寸
        self.myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.fullSize.width, height: self.fullSize.height - 113), style: .plain)
        
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
    
    func goDetail(_ index: Int) {
        print("goDetail : \(index)")
    }
    
    
// MARK: CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation :CLLocation = locations[0] as CLLocation
        
        // 更新自身定位座標
        self.myUserDefaults.set(currentLocation.coordinate.latitude, forKey: "userLatitude")
        self.myUserDefaults.set(currentLocation.coordinate.longitude, forKey: "userLongitude")
        self.myUserDefaults.synchronize()
        
        // 更新 table
        if let table = self.myTableView {
            self.myActivityIndicator.startAnimating()
            
            self.refreshAPIData()
            table.reloadData()
            
            self.myActivityIndicator.stopAnimating()
        }
    }
    
    // 更改定位權限時執行
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // 設置定位權限的紀錄
            self.myUserDefaults.set(false, forKey: "locationAuth")
            self.myUserDefaults.synchronize()
        } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            // 設置定位權限的紀錄
            self.myUserDefaults.set(true, forKey: "locationAuth")
            
            // 更新記錄的座標 for 取得有限數量的資料
            for type in ["hotel", "landmark", "park", "toilet"] {
                self.myUserDefaults.set(0.0, forKey: "\(type)RecordLatitude")
                self.myUserDefaults.set(0.0, forKey: "\(type)RecordLongitude")
            }

            self.myUserDefaults.synchronize()

            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
    }
    
    
// MARK: UITableViewDelegate methods
    
    // 必須實作的方法：有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiData.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        // 設置 Accessory 按鈕樣式
        cell!.accessoryType = .disclosureIndicator
        
        // 這筆資料
        let thisData = self.apiData[self.apiDataForDistance[indexPath.row].index]
        
        // 顯示的內容
        if let myLabel = cell!.textLabel {
            if let title = thisData["stitle"] as? String {
                myLabel.text = title as String
            } else if let title = thisData["ParkName"] as? String {
                myLabel.text = title as String
            } else if let title = thisData["單位名稱"] as? String {
                myLabel.text = title as String
            }
        }
        
        // 距離
        cell!.detailTextLabel?.text = ""
        
        // 有定位權限
        let locationAuth = myUserDefaults.object(forKey: "locationAuth") as? Bool
        if locationAuth != nil && locationAuth! {
            // 取得目前使用者座標
            let userLatitude = myUserDefaults.object(forKey: "userLatitude") as? Double
            let userLongitude = myUserDefaults.object(forKey: "userLongitude") as? Double
            let userLocation = CLLocation(latitude: userLatitude!, longitude: userLongitude!)
            
            // 這筆資料的座標
            var thisDataLatitude = 0.0
            if let num = thisData["latitude"] as? String {
                thisDataLatitude = Double(num)!
            } else if let num = thisData["Latitude"] as? String {
                thisDataLatitude = Double(num)!
            } else if let num = thisData["緯度"] as? String {
                thisDataLatitude = Double(num)!
            }
            
            var thisDataLongitude = 0.0
            if let num = thisData["longitude"] as? String {
                thisDataLongitude = Double(num)!
            } else if let num = thisData["Longitude"] as? String {
                thisDataLongitude = Double(num)!
            } else if let num = thisData["經度"] as? String {
                thisDataLongitude = Double(num)!
            }
            if thisDataLatitude == 0.0 && thisDataLongitude == 0.0 {
                cell!.detailTextLabel?.text = ""
            } else {
                let thisDataLocation = CLLocation(latitude: thisDataLatitude, longitude: thisDataLongitude)
                
                let distance = Int(userLocation.distance(from: thisDataLocation))
                var detail = ""
                if distance > 20000 {
                    detail = "超過 20 KM"
                } else if distance > 1000 {
                    detail = "\(Double(Int(distance / 100)) / 10.0) KM"
                } else if distance > 100 {
                    detail = "\(Int(distance / 10))0 M"
                } else {
                    detail = "\(distance) M"
                }
                
                cell!.detailTextLabel?.text = detail
            }
        }
        
        return cell!
    }
    
    // 點選 cell 後執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.goDetail(indexPath.row)
    }

    
// MARK: NSURLSessionDownloadDelegate Methods
    
    // 下載完成
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try? Data(contentsOf: location)
            try data?.write(to: self.targetUrl, options: .atomic)
            print("普通獲取遠端資訊的方式：儲存資訊成功")

            // 更新獲取資料的日期
            self.myUserDefaults.set(self.todayDateInt, forKey: self.fetchType + "FetchDate")
            self.myUserDefaults.synchronize()
            
            DispatchQueue.main.async(execute: {
                self.addTable(self.targetUrl)
            })

        } catch {
            print("普通獲取遠端資訊的方式：儲存資訊失敗")
        }

    }
    
    
// MARK: functional methods
    
    // 普通獲取遠端資訊的方式
    func normalGet(_ myUrl :String) {
        if let url = URL(string: myUrl) {
            // 設置為預設的 session 設定
            let sessionWithConfigure = URLSessionConfiguration.default
            
            // 設置委任對象
            let session = Foundation.URLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: nil)
            
            // 設置遠端 API 網址
            let dataTask = session.downloadTask(with: url)
            
            // 執行動作
            dataTask.resume()
        }
    }
    
    // 解析 json 檔案
    func jsonParse(_ url :URL) {
        do {
            let dict = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: JSONSerialization.ReadingOptions.allowFragments) as! [String:[String:AnyObject]]
            
            let dataArr = dict["result"]!["results"] as! [AnyObject]
            
            self.apiDataAll = dataArr

            self.refreshAPIData()
            
        } catch {
            print("解析 json 失敗")
        }
        
    }
    
    // 自資料取得緯度與經度
    func fetchLatitudeAndLongitudeFromData(_ data :AnyObject) -> (latitude:Double, longitude:Double) {
        var latitude = 0.0
        if let num = data["latitude"] as? String {
            latitude = Double(num)!
        } else if let num = data["Latitude"] as? String {
            latitude = Double(num)!
        } else if let num = data["緯度"] as? String {
            latitude = Double(num)!
        }
        
        var longitude = 0.0
        if let num = data["longitude"] as? String {
            longitude = Double(num)!
        } else if let num = data["Longitude"] as? String {
            longitude = Double(num)!
        } else if let num = data["經度"] as? String {
            longitude = Double(num)!
        }
        
        return (latitude, longitude)
    }
    
    // 將資料填入 apiDataForDistance
    func fillIntoAPIDataForDistanceAndSort(_ allData :[AnyObject]) {
        self.apiDataForDistance = []
        
        var index = 0
        for data in allData {
            
            let (latitude, longitude) = self.fetchLatitudeAndLongitudeFromData(data)

            self.apiDataForDistance.append(Coordinate(
                index: index ,
                latitude: latitude ,
                longitude: longitude ))
            
            index += 1
        }

        self.apiDataForDistance.sort(by: <)
        
    }
    
    // 依據所有資料與使用者定位的距離 取得有限數量資料
    func reloadAPIData() {
        guard self.apiDataAll != nil else {
            return
        }

        // 有定位權限
        let locationAuth = myUserDefaults.object(forKey: "locationAuth") as? Bool
        if locationAuth != nil && locationAuth! {

            // 取得目前使用者座標
            let userLatitude = myUserDefaults.object(forKey: "userLatitude") as? Double
            let userLongitude = myUserDefaults.object(forKey: "userLongitude") as? Double
            let userLocation = CLLocation(latitude: userLatitude!, longitude: userLongitude!)
            
            // 記錄的座標
            let recordLatitude = myUserDefaults.object(forKey: self.fetchType + "RecordLatitude") as? Double ?? 0.0
            let recordLongitude = myUserDefaults.object(forKey: self.fetchType + "RecordLongitude") as? Double ?? 0.0
            let recordLocation = CLLocation(latitude: recordLatitude, longitude: recordLongitude)
            
            // 超過限定距離才重新取得有限數量資料
            if userLocation.distance(from: recordLocation) > self.limitDistance {

                // 將所有資料依照與使用者距離重新排序
                self.fillIntoAPIDataForDistanceAndSort(self.apiDataAll)
      
                var tempAPIData :[AnyObject] = []
                var tempAPIDataForDistance :[Coordinate] = []
                for index in 0...self.limitNumber {
                    let tempCoordinate = self.apiDataForDistance[index]
                    let tempData = self.apiDataAll[tempCoordinate.index]
                    
                    tempAPIData.append(tempData)
                    
                    let (latitude, longitude) = self.fetchLatitudeAndLongitudeFromData(tempData)

                    tempAPIDataForDistance.append(
                        Coordinate(
                            index: index,
                            latitude: latitude,
                            longitude: longitude))
                }
                
                self.apiData = tempAPIData
                self.apiDataForDistance = tempAPIDataForDistance
                
                // 更新記錄的座標
                myUserDefaults.set(userLatitude, forKey: self.fetchType + "RecordLatitude")
                myUserDefaults.set(userLongitude, forKey: self.fetchType + "RecordLongitude")
                myUserDefaults.synchronize()
            } else {
                self.apiData = self.apiDataAll
            }
        } else {
            // 無定位權限 取得所有資料
            self.apiData = self.apiDataAll
        }

    }
    
    func refreshAPIData() {
        guard self.apiDataAll != nil else {
            return
        }

        // 依據所有資料與使用者定位的距離 取得有限數量資料
        self.reloadAPIData()
        
        // 將有限數量資料依照與使用者距離重新排序
        self.fillIntoAPIDataForDistanceAndSort(self.apiData)

    }
    
}

