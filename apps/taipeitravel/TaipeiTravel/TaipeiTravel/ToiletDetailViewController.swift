//
//  ToiletDetailViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/7.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ToiletDetailViewController: DetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchType = "toilet"

        let latitude = info["latitude"] as? Double ?? 0.0
        let longitude = info["longitude"] as? Double ?? 0.0
        hasMap = latitude == 0.0 && longitude == 0.0 ? false : true
        
        // 設置資訊
        detail = [
            "地圖",
            info["type"] as? String ?? "",
            info["address"] as? String ?? "",
            info["number"] as? String ?? "",
            info["type1"] as? String ?? "",
            info["type2"] as? String ?? "",
            info["type3"] as? String ?? "",
        ]

        self.title = info["title"] as? String ?? "標題"
        
    }
    
    
    // MARK: UITableViewDelegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasMap ? 7 : 6
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell

        cell.accessoryType = .none
        
        if self.hasMap {
            var content = ""
            if indexPath.row == 4 {
                content = "場所提供行動不便者使用廁所："
                let yes = self.detail[indexPath.row] 
                if yes == "v" {
                    content = content + " 有"
                } else {
                    content = content + " 無"
                }
                cell.textLabel?.text = content
            } else if indexPath.row == 5 {
                content = "親子廁間："
                let yes = self.detail[indexPath.row] 
                if yes == "v" {
                    content = content + " 有"
                } else {
                    content = content + " 無"
                }
                cell.textLabel?.text = content
            } else if indexPath.row == 6 {
                content = "貼心公廁："
                let yes = self.detail[indexPath.row] 
                if yes == "v" {
                    content = content + " 有"
                } else {
                    content = content + " 無"
                }
                cell.textLabel?.text = content
            } else {
                cell.textLabel?.text = self.detail[indexPath.row] 
            }

            if indexPath.row == 0 {
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "類型：" + (cell.textLabel?.text)!
            }
        
        } else {
            cell.textLabel?.text = self.detail[indexPath.row + 1] 
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "類型：" + (cell.textLabel?.text)!
            }
        }
        
        if indexPath.row > (self.hasMap ? 1 : 0) {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
        }
        
        return cell
    }
    
}
