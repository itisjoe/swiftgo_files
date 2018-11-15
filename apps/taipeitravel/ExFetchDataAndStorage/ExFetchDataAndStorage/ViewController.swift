//
//  ViewController.swift
//  ExFetchDataAndStorage
//
//  Created by joe feng on 2016/6/3.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate {
    let taipeiDataURL = "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid="

    var hotelURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("hotel.json")
        } catch {
            fatalError("Error getting hotel URL from document directory.")
        }
    }()
    
    var touringSiteTargetURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("touringSite.json")
        } catch {
            fatalError("Error getting touringSite URL from document directory.")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 台北住宿資料 中文
        let strHotelID = "6f4e0b9b-8cb1-4b1d-a5c4-febd90f62469" //&limit=2&offset=0"
        self.simpleGet(taipeiDataURL + strHotelID, targetURL: hotelURL)
        
        // 台北景點資料 中文
        let strTouringSiteID = "36847f3f-deff-4183-a5bb-800737591de5"
        self.normalGet(taipeiDataURL + strTouringSiteID)
    
    }

    // 基本獲取遠端資訊的方式
    func simpleGet(_ myUrl :String, targetURL :URL) {
        URLSession.shared.dataTask(with: URL(string: myUrl)!, completionHandler: {data, response, error in
            
            // 建立檔案
            do {
                // 將取得的資訊轉成字串印出
                //print(String(data: data!, encoding: .utf8))

                try data?.write(to: targetURL, options: .atomic)
                print("基本獲取遠端資訊的方式：儲存資訊成功")
                self.jsonParse(targetURL)
            } catch {
                print("基本獲取遠端資訊的方式：儲存資訊失敗")
            }
            
        }).resume()
    }
    
    // 普通獲取遠端資訊的方式
    func normalGet(_ myUrl :String) {
        if let url = URL(string: myUrl) {
            // 設置為預設的 session 設定
            let sessionWithConfigure = URLSessionConfiguration.default
            
            // 設置委任對象
            let session = URLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: nil)
            
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

            print(dict.count)
            let dataArr = dict["result"]!["results"] as! [AnyObject]
            print(dataArr.count)
            print(dataArr[3]["stitle"] as Any)
        } catch {
            print("解析 json 失敗")
        }

    }

// MARK: URLSessionDownloadDelegate Methods
    
    // 下載完成
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("下載完成")
        
        do {
            let data = try? Data(contentsOf: location)
            try data?.write(to: touringSiteTargetURL, options: .atomic)
            print("普通獲取遠端資訊的方式：儲存資訊成功")
            self.jsonParse(touringSiteTargetURL)
        } catch {
            print("普通獲取遠端資訊的方式：儲存資訊失敗")
        }

    }
    
    // 下載過程中
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // 如果 totalBytesExpectedToWrite 一直為 -1
        // 表示遠端主機未提供完整檔案大小資訊
        print("下載進度： \(totalBytesWritten)/\(totalBytesExpectedToWrite)")
    }

}
