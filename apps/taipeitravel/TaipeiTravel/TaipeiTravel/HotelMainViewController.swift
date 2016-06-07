//
//  HotelMainViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/6.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import CoreLocation

class HotelMainViewController: BaseMainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 導覽列標題
        self.title = "住宿"
        
        // 獲取類型
        self.fetchType = "hotel"
        
        // 台北住宿資料 ID
        self.strTargetID = "6f4e0b9b-8cb1-4b1d-a5c4-febd90f62469" //&limit=3&offset=0"
        
        self.targetUrl = self.documentsPath + self.fetchType + ".json"
        
        // 取得 API 資料
        self.addData()
    }
    
    override func goDetail(index: Int) {
        let thisData = self.apiData[self.apiDataForDistance[index].index]
        let title = thisData["stitle"] as? String ?? ""
        let intro = thisData["xbody"] as? String ?? ""
        let type = thisData["CAT2"] as? String ?? ""
        let address = thisData["address"] as? String ?? ""
        
        var latitude = 0.0
        if let num = thisData["latitude"] as? NSString {
            latitude = num.doubleValue
        }
        
        var longitude = 0.0
        if let num = thisData["longitude"] as? NSString {
            longitude = num.doubleValue
        }
        
        let info :[String:AnyObject] = [
            "title" : title,
            "intro" : intro,
            "type" : type,
            "address" : address,
            "latitude" : latitude,
            "longitude" : longitude,
        ]
        
        
        self.myUserDefaults.setObject(info, forKey: "\(self.fetchType)Detail")
        self.myUserDefaults.synchronize()
        
        print(info["title"] as? String ?? "NO Title")
        
        self.navigationController?.pushViewController(HotelDetailViewController(), animated: true)
        
    }
    
}
