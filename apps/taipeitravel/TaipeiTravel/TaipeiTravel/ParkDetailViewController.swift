//
//  ParkDetailViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/7.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ParkDetailViewController: DetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchType = "park"
        
        // 取得單筆資訊
        let info :[String:AnyObject] = myUserDefaults.objectForKey("\(self.fetchType)Detail") as? [String:AnyObject] ?? [:]
        
        let latitude = info["latitude"] as? Double ?? 0.0
        let longitude = info["longitude"] as? Double ?? 0.0
        hasMap = latitude == 0.0 && longitude == 0.0 ? false : true
        
        // 設置資訊
        detail = [
            "地圖",
            info["type"] as? String ?? "",
            info["location"] as? String ?? "",
            info["area"] as? String ?? "",
            info["intro"] as? String ?? "",
        ]
        
        self.title = info["title"] as? String ?? "標題"
        
    }
    

// MARK: UITableViewDelegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasMap ? 5 : 4
    }

    
}
