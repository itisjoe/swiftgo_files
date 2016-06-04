//
//  ViewController.swift
//  ExFetchDataAndStorage
//
//  Created by joe feng on 2016/6/3.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    var taipeiDataUrl :String!
    var documentsPath :String!
    var touringSiteTargetUrl :String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 應用程式儲存檔案的目錄路徑
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        self.documentsPath = urls[urls.count-1].absoluteString
        
        self.taipeiDataUrl = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid="
        
        // 台北住宿資料 中文
        let strHotelID = "6f4e0b9b-8cb1-4b1d-a5c4-febd90f62469" //&limit=2&offset=0"
        self.simpleGet(taipeiDataUrl + strHotelID, targetPath: self.documentsPath + "hotel.json")
        
        // 台北景點資料 中文
        let strTouringSiteID = "36847f3f-deff-4183-a5bb-800737591de5"
        self.touringSiteTargetUrl = self.documentsPath + "touringSite.json"
        self.normalGet(taipeiDataUrl + strTouringSiteID)
    
    }

    // 基本獲取遠端資訊的方式
    func simpleGet(myUrl :String, targetPath :String) {
        if let url = NSURL(string: myUrl) {
            NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in

                // 建立檔案
                let fileurl = NSURL(string: targetPath)
                if let result = data?.writeToURL(fileurl!, atomically: true) {
                    if result {
                        print("基本獲取遠端資訊的方式：儲存資訊成功")
                        self.jsonParse(fileurl!)
                    } else {
                        print("基本獲取遠端資訊的方式：儲存資訊失敗")
                    }
                }

            }.resume()
        }

    }
    
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
    
    // 解析 json 檔案
    func jsonParse(url :NSURL) {
        do {
            let dict = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: url)!, options: NSJSONReadingOptions.AllowFragments) as! [String:[String:AnyObject]]
            
            print(dict.count)

            let dataArr = dict["result"]!["results"] as! [AnyObject]
            
            print(dataArr.count)
            
            print(dataArr[3]["stitle"])
            
        } catch {
            print("解析 json 失敗")
        }

    }

// MARK: NSURLSessionDownloadDelegate Methods
    
    // 下載完成
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("下載完成")
        
        let targetUrl = NSURL(string: self.touringSiteTargetUrl)!
        let data = NSData(contentsOfURL: location)
        if ((data?.writeToURL(targetUrl, atomically: true)) != nil) {
            print("普通獲取遠端資訊的方式：儲存資訊成功")
            self.jsonParse(targetUrl)
        } else {
            print("普通獲取遠端資訊的方式：儲存資訊失敗")
            
        }
    }
    
    // 下載過程中
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // 如果 totalBytesExpectedToWrite 一直為 -1
        // 表示遠端主機未提供完整檔案大小資訊
        print("下載進度： \(totalBytesWritten)/\(totalBytesExpectedToWrite)")
    }

}