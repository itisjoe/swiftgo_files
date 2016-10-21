//
//  HotelDetailViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/7.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class HotelDetailViewController: DetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchType = "hotel"

        let latitude = info["latitude"] as? Double ?? 0.0
        let longitude = info["longitude"] as? Double ?? 0.0
        hasMap = latitude == 0.0 && longitude == 0.0 ? false : true
        
        // 設置資訊
        detail = [
            "地圖",
            info["type"] as? String ?? "",
            info["address"] as? String ?? "",
            info["intro"] as? String ?? "",
        ]
        
        self.title = info["title"] as? String ?? "標題"

    }

    
// MARK: UITableViewDelegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasMap ? 4 : 3
    }

    // 設置 cell 的高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(44.0)
        
        if (self.hasMap && indexPath.row == 3) || (!self.hasMap && indexPath.row == 2) {
            // intro height
            height = self.myTableView.frame.size.height - height * CGFloat(indexPath.row + 1)
        } else if (self.hasMap && indexPath.row == 2) || (!self.hasMap && indexPath.row == 1) {
            // address height
            height = 2.0 * height
        }
        
        if indexPath.row == self.selectedRowIndex {
            height = max(height, self.rowHeight + 5)
        }
        
        return height
    }
    
}
