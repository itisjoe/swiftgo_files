//
//  MoreViewController.swift
//  ToDo
//
//  Created by joe feng on 2016/6/17.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let fullSize :CGSize = UIScreen.mainScreen().bounds.size
    let myUserDefaults = NSUserDefaults.standardUserDefaults()
    var soundOpen:Int? = 0
    var mySwitch :UISwitch!
    var myTableView :UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "關於"
        
        // 建立 UITableView
        self.myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.fullSize.width, height: self.fullSize.height - 64), style: .Grouped)
        self.myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.allowsSelection = true
        self.view.addSubview(self.myTableView)
        
        // 音效開關
        mySwitch = UISwitch()
        soundOpen = myUserDefaults.objectForKey("soundOpen") as? Int
        mySwitch.on = soundOpen == 1 ? true : false
        mySwitch.addTarget(self, action: #selector(MoreViewController.onSwitchChange), forControlEvents: .ValueChanged)
    }

    
// MARK: Button actions

    func onSwitchChange(sender :UISwitch) {
        myUserDefaults.setObject((sender.on ? 1 : 0 ), forKey: "soundOpen")
        myUserDefaults.synchronize()
    }
    
    func goFB() {
        let requestUrl = NSURL(string: "https://www.facebook.com/1640636382849659")
        UIApplication.sharedApplication().openURL(requestUrl!)
    }
    
    func goSoundSource() {
        let requestUrl = NSURL(string: "http://www.pacdv.com/sounds")
        UIApplication.sharedApplication().openURL(requestUrl!)
    }

    
// MARK: UITableViewDelegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.accessoryType = .None
        
        if indexPath.section == 0 { // 更多 - 已完成事項
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "已完成事項"

        } else if indexPath.section == 1 { // 設定 - 音效 switch
            cell.textLabel?.text = "音效"
            cell.accessoryView = mySwitch

        } else if indexPath.section == 2 { // 支援 - fb
            let fbButton = UIButton(frame: CGRect(x: 15, y: 0, width: fullSize.width, height: 40))
            fbButton.addTarget(self, action: #selector(MoreViewController.goFB), forControlEvents: .TouchUpInside)
            fbButton.setTitle("在 Facebook 上與我們聯絡", forState: .Normal)
            fbButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            fbButton.contentHorizontalAlignment = .Left
            cell.contentView.addSubview(fbButton)

        } else if indexPath.section == 3 { // 來源 - 音效
            let button = UIButton(frame: CGRect(x: 15, y: 0, width: fullSize.width, height: 40))
            button.addTarget(self, action: #selector(MoreViewController.goSoundSource), forControlEvents: .TouchUpInside)
            button.setTitle("音效： PacDV", forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.contentHorizontalAlignment = .Left
            cell.contentView.addSubview(button)
        }
        
        return cell
    }
    
    // 點選 cell 後執行的動作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            self.navigationController?.pushViewController(ChechedRecordsViewController(), animated: true)
        }
    }
    
    // 有幾組 section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    // 每個 section 的標題
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = "來源"
        if section == 0 {
            title = "更多"
        } else if section == 1 {
            title = "設定"
        } else if section == 2 {
            title = "支援"
        }
        
        return title
    }

}
