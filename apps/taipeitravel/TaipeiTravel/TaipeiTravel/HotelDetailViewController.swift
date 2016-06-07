//
//  HotelDetailViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/7.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class HotelDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let fullSize :CGSize = UIScreen.mainScreen().bounds.size
    let myUserDefaults :NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let fetchType :String = "hotel"
    var detail :[String] = []
    var hasMap :Bool = false
    var myTableView :UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 樣式
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 取得飯店資訊
        let info :[String:AnyObject] = myUserDefaults.objectForKey("\(self.fetchType)Detail") as? [String:AnyObject] ?? [:]
        
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
        
        self.title = info["title"] as? String ?? "住宿飯店標題"

        // 建立 UITableView 並設置原點及尺寸
        self.myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.fullSize.width, height: self.fullSize.height - 113), style: .Plain)
        
        // 註冊重複使用的 cell
        self.myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // 設置委任對象
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        // 是否可以點選 cell
        self.myTableView.allowsSelection = true
        
        // 加入到畫面中
        self.view.addSubview(self.myTableView)

    }

    
// MARK: UITableViewDelegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasMap ? 4 : 3
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        if self.hasMap {
            if indexPath.row == 0 {
                cell.accessoryType = .DisclosureIndicator
            }
            cell.textLabel?.text = self.detail[indexPath.row] ?? ""
        } else {
            cell.textLabel?.text = self.detail[indexPath.row + 1] ?? ""
        }
        
        if indexPath.row > (self.hasMap ? 1 : 0) {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .ByWordWrapping
        }
        
        return cell
    }
    
    // 點選 cell 後執行的動作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if self.hasMap && indexPath.row == 0 {
            self.navigationController?.pushViewController(HotelMapViewController(), animated: true)
        }
    }
    
    // 設置 cell 的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = CGFloat(44.0)
        
        if (self.hasMap && indexPath.row == 3) || (!self.hasMap && indexPath.row == 2) {
            // intro height
            height = self.myTableView.frame.size.height - height * CGFloat(indexPath.row + 1)
        } else if (self.hasMap && indexPath.row == 2) || (!self.hasMap && indexPath.row == 1) {
            // address height
            height = 2.0 * height
        }
        
        return height
    }
    
}
