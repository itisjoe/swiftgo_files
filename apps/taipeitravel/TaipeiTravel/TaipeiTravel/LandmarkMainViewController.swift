//
//  LandmarkMainViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/6.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import CoreLocation

class LandmarkMainViewController: BaseMainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 導覽列標題
        self.title = "景點"
        
        // 獲取類型
        self.fetchType = "landmark"
        
        // 台北景點資料 ID
        self.strTargetID = "36847f3f-deff-4183-a5bb-800737591de5"
        
        self.targetUrl = self.documentsPath + self.fetchType + ".json"
        
        // 取得 API 資料
        self.addData()
    }
    
    override func goDetail(index: Int) {
        let thisData = self.apiData[self.apiDataForDistance[index].index]
        let title = thisData["stitle"] as? String ?? ""
        let intro = thisData["xbody"] as? String ?? ""
        let openTime = thisData["MEMO_TIME"] as? String ?? "無開放時間資訊"
        let transportation = thisData["info"] as? String ?? "無交通資訊"
        let type = thisData["CAT2"] as? String ?? ""
        let address = thisData["address"] as? String ?? "無地址資訊"
        
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
            "openTime" : openTime,
            "transportation" : transportation,
            "latitude" : latitude,
            "longitude" : longitude,
            ]
        
        
        self.myUserDefaults.setObject(info, forKey: "\(self.fetchType)Detail")
        self.myUserDefaults.synchronize()
        
        print(info["title"] as? String ?? "NO Title")
        
        self.navigationController?.pushViewController(LandmarkDetailViewController(), animated: true)
        
    }
}
