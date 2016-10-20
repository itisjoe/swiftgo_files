//
//  ViewController.swift
//  ExFetchDataAndStorage
//
//  Created by joe feng on 2016/6/3.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate {
    var taipeiDataUrl :String!
    var documentsPath :String!
    var touringSiteTargetUrl :String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 應用程式儲存檔案的目錄路徑
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        documentsPath = urls[urls.count-1].absoluteString
        
        taipeiDataUrl = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid="
        
        // 台北住宿資料 中文
        let strHotelID = "6f4e0b9b-8cb1-4b1d-a5c4-febd90f62469" //&limit=2&offset=0"
        self.simpleGet(taipeiDataUrl + strHotelID, targetPath: documentsPath + "hotel.json")
        
        // 台北景點資料 中文
        let strTouringSiteID = "36847f3f-deff-4183-a5bb-800737591de5"
        touringSiteTargetUrl = documentsPath + "touringSite.json"
        self.normalGet(taipeiDataUrl + strTouringSiteID)
    
    }

    // 基本獲取遠端資訊的方式
    func simpleGet(_ myUrl :String, targetPath :String) {
        URLSession.shared.dataTask(with: URL(string: myUrl)!, completionHandler: {data, response, error in
            
            // 建立檔案
            let fileurl = URL(string: targetPath)!
            do {
                // 將取得的資訊轉成字串印出
                //print(String(data: data!, encoding: .utf8))

                try data?.write(to: fileurl, options: .atomic)
                print("基本獲取遠端資訊的方式：儲存資訊成功")
                self.jsonParse(fileurl)
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
            print(dataArr[3]["stitle"])
        } catch {
            print("解析 json 失敗")
        }

    }

// MARK: URLSessionDownloadDelegate Methods
    
    // 下載完成
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("下載完成")
        
        let targetUrl = URL(string: touringSiteTargetUrl)!
        do {
            let data = try? Data(contentsOf: location)
            try data?.write(to: targetUrl, options: .atomic)
            print("普通獲取遠端資訊的方式：儲存資訊成功")
            self.jsonParse(targetUrl)
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
