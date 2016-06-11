//
//  InfoMainViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/6.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class InfoMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    let fullSize :CGSize = UIScreen.mainScreen().bounds.size
    var myTableView :UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 樣式
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "關於"
        
        // 建立 UITableView 並設置原點及尺寸
        self.myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.fullSize.width, height: self.fullSize.height - 113), style: .Grouped)
        
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

    func goFB() {
        let requestUrl = NSURL(string: "https://www.facebook.com/1640636382849659")
        UIApplication.sharedApplication().openURL(requestUrl!)
    }
    
    func goIconSource() {
        let requestUrl = NSURL(string: "http://www.flaticon.com/")
        UIApplication.sharedApplication().openURL(requestUrl!)
    }

    func goDataSource() {
        let requestUrl = NSURL(string: "http://data.taipei/")
        UIApplication.sharedApplication().openURL(requestUrl!)
    }

    
// MARK: UITableViewDelegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1) ? 2 : 1
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let fbButton = UIButton(frame: CGRect(x: 15, y: 0, width: fullSize.width, height: 40))
                fbButton.addTarget(self, action: #selector(InfoMainViewController.goFB), forControlEvents: .TouchUpInside)
                fbButton.setTitle("在 Facebook 上與我們聯絡", forState: .Normal)
                fbButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                fbButton.contentHorizontalAlignment = .Left
                cell.contentView.addSubview(fbButton)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let button = UIButton(frame: CGRect(x: 15, y: 0, width: fullSize.width, height: 40))
                button.addTarget(self, action: #selector(InfoMainViewController.goDataSource), forControlEvents: .TouchUpInside)
                button.setTitle("資料： 臺北市政府資料開放平台", forState: .Normal)
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                button.contentHorizontalAlignment = .Left
                cell.contentView.addSubview(button)
            } else {
                let button = UIButton(frame: CGRect(x: 15, y: 0, width: fullSize.width, height: 40))
                button.addTarget(self, action: #selector(InfoMainViewController.goIconSource), forControlEvents: .TouchUpInside)
                button.setTitle("圖示： FLATICON", forState: .Normal)
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                button.contentHorizontalAlignment = .Left
                cell.contentView.addSubview(button)
            }
        } else if indexPath.section == 2 {
            cell.textLabel?.text = "當開啟定位服務時，顯示資料僅會列出距離目前定位位置較近的地點。"
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .ByWordWrapping
        }
        
        return cell
    }
    
    // 點選 cell 後執行的動作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // 有幾組 section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    // 每個 section 的標題
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = "說明"
        if section == 0 {
            title = "支援"
        } else if section == 1 {
            title = "來源"
        }

        return title
    }
    
    // 設置 cell 的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = CGFloat(44.0)
        
        if indexPath.section == 2 {
            height = 120.0
        }
        
        return height
    }
    
}
