//
//  ToiletMainViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/7.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import CoreLocation

class ToiletMainViewController: BaseMainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 導覽列標題
        self.title = "廁所"
        
        // 獲取類型
        self.fetchType = "toilet"
        
        // 台北景點資料 ID
        self.strTargetID = "008ed7cf-2340-4bc4-89b0-e258a5573be2"
        
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
        let type = thisData["類別"] as? String ?? ""

        var number = thisData["座數"] as? String ?? ""
        if number != "" {
            number = "座數： " + number
        }

        let title = thisData["單位名稱"] as? String ?? ""
        let address = thisData["地址"] as? String ?? ""

        
        let type1 = thisData["場所提供行動不便者使用廁所"] as? String ?? ""
        let type2 = thisData["親子廁間"] as? String ?? ""
        let type3 = thisData["貼心公廁"] as? String ?? ""
        
        var latitude = 0.0
        if let num = thisData["緯度"] as? String {
            latitude = Double(num)!
        }
        
        var longitude = 0.0
        if let num = thisData["經度"] as? String {
            longitude = Double(num)!
        }
        
        let info :[String:AnyObject] = [
            "title" : title as AnyObject,
            "number" : number as AnyObject,
            "type" : type as AnyObject,
            "address" : address as AnyObject,
            "type1" : type1 as AnyObject,
            "type2" : type2 as AnyObject,
            "type3" : type3 as AnyObject,
            "latitude" : latitude as AnyObject,
            "longitude" : longitude as AnyObject,
        ]

        print(info["title"] as? String ?? "NO Title")
        
        let detailViewController = ToiletDetailViewController()
        detailViewController.info = info
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

}
