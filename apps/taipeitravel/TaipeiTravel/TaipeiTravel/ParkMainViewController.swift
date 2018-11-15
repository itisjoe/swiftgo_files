//
//  ParkMainViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/6.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import CoreLocation

class ParkMainViewController: BaseMainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 導覽列標題
        self.title = "公園"
        
        // 獲取類型
        self.fetchType = "park"
        
        // 台北景點資料 ID
        self.strTargetID = "8f6fcb24-290b-461d-9d34-72ed1b3f51f0"
        
        self.targetUrl = {
            do {
                return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(self.fetchType + ".json")
            } catch {
                fatalError("Error getting file URL from document directory.")
            }
        }()

        // 取得 API 資料
        self.addData()
    }
    
    override func goDetail(_ index: Int) {
        let thisData = self.apiData[self.apiDataForDistance[index].index]
        let title = thisData["ParkName"] as? String ?? ""
        let intro = thisData["Introduction"] as? String ?? ""
        var area = thisData["Area"] as? String ?? "無面積資訊"
        
        if area != "無面積資訊" {
            area = "面積： " + area + " 平方公尺"
        }
        
        let type = thisData["ParkType"] as? String ?? ""
        let location = thisData["Location"] as? String ?? "無地址資訊"
        
        var latitude = 0.0
        if let num = thisData["Latitude"] as? String {
            latitude = Double(num)!
        }
        
        var longitude = 0.0
        if let num = thisData["Longitude"] as? String {
            longitude = Double(num)!
        }
        
        let info :[String:AnyObject] = [
            "title" : title as AnyObject,
            "intro" : intro as AnyObject,
            "type" : type as AnyObject,
            "location" : location as AnyObject,
            "area" : area as AnyObject,
            "latitude" : latitude as AnyObject,
            "longitude" : longitude as AnyObject,
        ]

        print(info["title"] as? String ?? "NO Title")

        let detailViewController = ParkDetailViewController()
        detailViewController.info = info
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}
