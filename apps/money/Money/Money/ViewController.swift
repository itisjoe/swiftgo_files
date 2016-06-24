//
//  ViewController.swift
//  Money
//
//  Created by joe feng on 2016/6/20.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let fullsize = UIScreen.mainScreen().bounds.size
    let myUserDefaults = NSUserDefaults.standardUserDefaults()
    var db :SQLiteConnect?
    let myFormatter = NSDateFormatter()
    var currentDate :NSDate = NSDate()
    
    var days :[String]! = []
    var myRecords :[String:[[String:String]]]! = [:]
    var currentMonthLabel :UILabel!
    var prevBtn :UIButton!
    var nextBtn :UIButton!
    var amountLabel :UILabel!
    var myTableView :UITableView!
    var selectedBackgroundView :UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 基本設定
        self.title = "記帳"
        self.view.backgroundColor = UIColor.init(red: 0.092, green: 0.092, blue: 0.092, alpha: 1)
        self.navigationController?.navigationBar.translucent = false
        
        // 連接資料庫
        let dbFileName = myUserDefaults.objectForKey("dbFileName") as! String
        db = SQLiteConnect(file: dbFileName)
        
        // 導覽列右邊設定按鈕
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings")!, style: .Plain, target: self, action: #selector(ViewController.settingsBtnAction))

        // 目前年月
        currentMonthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullsize.width * 0.7, height: 50))
        currentMonthLabel.center = CGPoint(x: fullsize.width * 0.5, y: 35)
        currentMonthLabel.textColor = UIColor.whiteColor()
        myFormatter.dateFormat = "yyyy 年 MM 月"
        currentMonthLabel.text = myFormatter.stringFromDate(currentDate)
        currentMonthLabel.textAlignment = .Center
        currentMonthLabel.font = UIFont(name: "Helvetica Light", size: 32.0)
        currentMonthLabel.tag = 701
        self.view.addSubview(currentMonthLabel)
        
        // 前一月份按鈕
        prevBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        prevBtn.center = CGPoint(x: fullsize.width * 0.1, y: 35)
        prevBtn.setImage(UIImage(named: "prev"), forState: .Normal)
        prevBtn.addTarget(self, action: #selector(ViewController.prevBtnAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(prevBtn)
        
        // 後一月份按鈕
        nextBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        nextBtn.center = CGPoint(x: fullsize.width * 0.9, y: 35)
        nextBtn.setImage(UIImage(named: "next"), forState: .Normal)
        nextBtn.addTarget(self, action: #selector(ViewController.nextBtnAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(nextBtn)
        
        // 總金額顯示文字
        var dollarSignLabel = UILabel(frame: CGRect(x: 15, y: 70, width: 80, height: 30))
        dollarSignLabel.font = UIFont(name: "Helvetica Light", size: 16.0)
        dollarSignLabel.textColor = UIColor.whiteColor()
        dollarSignLabel.text = "總計"
        self.view.addSubview(dollarSignLabel)
        dollarSignLabel = UILabel(frame: CGRect(x: fullsize.width - 35, y: 70, width: 30, height: 30))
        dollarSignLabel.font = UIFont(name: "Helvetica Light", size: 16.0)
        dollarSignLabel.textColor = UIColor.whiteColor()
        dollarSignLabel.text = "元"
        self.view.addSubview(dollarSignLabel)

        // 總金額
        let amount = 0.0
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        amountLabel = UILabel(frame: CGRect(x: 20, y: 70, width: fullsize.width - 65, height: 30))
        amountLabel.font = UIFont(name: "Helvetica Light", size: 24.0)
        amountLabel.textAlignment = .Right
        amountLabel.textColor = UIColor.whiteColor()
        amountLabel.text = "\(formatter.stringFromNumber(amount)!)"
        self.view.addSubview(amountLabel)
        
        // 花費記錄列表
        myTableView = UITableView(frame: CGRect(x: 0, y: 105, width: fullsize.width, height: fullsize.height - 169) , style: .Grouped)
        //myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.allowsSelection = true
        myTableView.backgroundColor = UIColor.blackColor()
        myTableView.separatorColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
        self.view.addSubview(myTableView)
        
        // 點選 cell 後的 UIView
        selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: fullsize.width, height: 44))
        selectedBackgroundView.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)

        // 底部新增記錄按鈕
        let addBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        addBtn.center = CGPoint(x: fullsize.width * 0.5, y: fullsize.height - 105)
        addBtn.addTarget(self, action: #selector(ViewController.addBtnAction), forControlEvents: .TouchUpInside)
        addBtn.setImage(UIImage(named:"add"), forState: .Normal)
        self.view.addSubview(addBtn)
    
    }

    override func viewWillAppear(animated: Bool) {
        let displayYearMonth = myUserDefaults.objectForKey("displayYearMonth") as? String
        if displayYearMonth != nil && displayYearMonth != "" {
            myFormatter.dateFormat = "yyyy-MM"
            currentDate = myFormatter.dateFromString(displayYearMonth!)!
            
            myUserDefaults.setObject("", forKey: "displayYearMonth")
            myUserDefaults.synchronize()
        }
        
        self.updateRecordsList()
    }
    
// MARK: functional methods
    
    // 更新列表
    func updateRecordsList() {
        myFormatter.dateFormat = "yyyy-MM"
        let yearMonth = myFormatter.stringFromDate(currentDate)
        if let mydb = db {
            days = []
            myRecords = [:]
            var total = 0.0
            
            let statement = mydb.fetch("records", cond: "yearMonth == '\(yearMonth)'", order: "createTime desc, id desc")
            while sqlite3_step(statement) == SQLITE_ROW{
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(statement, 1))) ?? ""
                let amount = sqlite3_column_double(statement, 2)
                let createDate = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(statement, 4))) ?? ""
                
                if createDate != "" {
                    if !days.contains(createDate) {
                        days.append(createDate)
                        myRecords[createDate] = []
                    }

                    myRecords[createDate]?.append([
                        "id":"\(id)",
                        "title":"\(title)",
                        "amount":"\(amount)"
                    ])
                    
                    total += amount
                }
            }
            sqlite3_finalize(statement)
            
            myTableView.reloadData()
            
            // 更新顯示金額
            amountLabel.text = String(format: "%g",total)
            
            // 更新年月
            myFormatter.dateFormat = "yyyy 年 MM 月"
            currentMonthLabel.text = myFormatter.stringFromDate(currentDate)
        }

    }
    
    // 切換月份
    func updateCurrentDate(dateComponents :NSDateComponents) {
        let cal = NSCalendar.currentCalendar()
        let newDate = cal.dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))
        
        currentDate = newDate!
        
        self.updateRecordsList()
    }

// MARK: Button actions

    // 前一個月
    func prevBtnAction() {
        let dateComponents = NSDateComponents()
        dateComponents.month = -1
        self.updateCurrentDate(dateComponents)
    }
    
    // 後一個月
    func nextBtnAction() {
        let dateComponents = NSDateComponents()
        dateComponents.month = 1
        self.updateCurrentDate(dateComponents)
    }
    
    // 前往[關於]頁面
    func settingsBtnAction() {
        self.navigationController?.pushViewController(MoreViewController(), animated: true)
    }
    
    // 前往[新增]頁面
    func addBtnAction() {
        myUserDefaults.setObject(0, forKey: "postID")
        myUserDefaults.synchronize()

        self.navigationController?.pushViewController(PostViewController(), animated: false)
    }

    
// MARK: UITableView Delegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = days[section]
        guard let records = myRecords[date] else {
            return 0
        }

        return records.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
        }
        
        cell!.textLabel?.textColor = UIColor.whiteColor()
        cell!.detailTextLabel?.textColor = UIColor.init(red: 0.88, green: 0.83, blue: 0.73, alpha: 1)
        cell!.selectedBackgroundView = selectedBackgroundView
        
        let date = days[indexPath.section]
        guard let records = myRecords[date] else {
            return cell!
        }

        // 顯示的內容
        cell!.detailTextLabel?.text = String(format: "%g",Float(records[indexPath.row]["amount"]!)!)
        cell!.textLabel?.text = records[indexPath.row]["title"]
        
        return cell!
    }
    
    // 點選 cell 後執行的動作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let date = days[indexPath.section]
        guard let records = myRecords[date] else {
            return
        }
        
        myUserDefaults.setObject(Int(records[indexPath.row]["id"]!), forKey: "postID")
        myUserDefaults.synchronize()
        
        self.navigationController?.pushViewController(PostViewController(), animated: true)
    }
    
    // 有幾個 section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return days.count
    }
    
    // section 標題
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return days[section]
    }
    
    // section 標題 高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    // section footer 高度
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (days.count - 1) == section ? 60 : 3
    }
    
    // section header 樣式
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.init(red: 0.88, green: 0.83, blue: 0.73, alpha: 1)
    }


}

