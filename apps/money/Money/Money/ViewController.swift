//
//  ViewController.swift
//  Money
//
//  Created by joe feng on 2016/6/20.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let fullsize = UIScreen.main.bounds.size
    let myUserDefaults = UserDefaults.standard
    var db :SQLiteConnect?
    let myFormatter = DateFormatter()
    var currentDate :Date = Date()
    
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
        self.navigationController?.navigationBar.isTranslucent = false
        
        // 連接資料庫
        let dbFileName = myUserDefaults.object(forKey: "dbFileName") as! String
        db = SQLiteConnect(file: dbFileName)
        
        // 導覽列右邊設定按鈕
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings")!, style: .plain, target: self, action: #selector(ViewController.settingsBtnAction))

        // 目前年月
        currentMonthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullsize.width * 0.7, height: 50))
        currentMonthLabel.center = CGPoint(x: fullsize.width * 0.5, y: 35)
        currentMonthLabel.textColor = UIColor.white
        myFormatter.dateFormat = "yyyy 年 MM 月"
        currentMonthLabel.text = myFormatter.string(from: currentDate)
        currentMonthLabel.textAlignment = .center
        currentMonthLabel.font = UIFont(name: "Helvetica Light", size: 32.0)
        currentMonthLabel.tag = 701
        self.view.addSubview(currentMonthLabel)
        
        // 前一月份按鈕
        prevBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        prevBtn.center = CGPoint(x: fullsize.width * 0.1, y: 35)
        prevBtn.setImage(UIImage(named: "prev"), for: .normal)
        prevBtn.addTarget(self, action: #selector(ViewController.prevBtnAction), for: .touchUpInside)
        self.view.addSubview(prevBtn)
        
        // 後一月份按鈕
        nextBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        nextBtn.center = CGPoint(x: fullsize.width * 0.9, y: 35)
        nextBtn.setImage(UIImage(named: "next"), for: .normal)
        nextBtn.addTarget(self, action: #selector(ViewController.nextBtnAction), for: .touchUpInside)
        self.view.addSubview(nextBtn)
        
        // 總金額顯示文字
        var dollarSignLabel = UILabel(frame: CGRect(x: 15, y: 70, width: 80, height: 30))
        dollarSignLabel.font = UIFont(name: "Helvetica Light", size: 16.0)
        dollarSignLabel.textColor = UIColor.white
        dollarSignLabel.text = "總計"
        self.view.addSubview(dollarSignLabel)
        dollarSignLabel = UILabel(frame: CGRect(x: fullsize.width - 35, y: 70, width: 30, height: 30))
        dollarSignLabel.font = UIFont(name: "Helvetica Light", size: 16.0)
        dollarSignLabel.textColor = UIColor.white
        dollarSignLabel.text = "元"
        self.view.addSubview(dollarSignLabel)

        // 總金額
        let amount = 0.0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        amountLabel = UILabel(frame: CGRect(x: 20, y: 70, width: fullsize.width - 65, height: 30))
        amountLabel.font = UIFont(name: "Helvetica Light", size: 24.0)
        amountLabel.textAlignment = .right
        amountLabel.textColor = UIColor.white
        amountLabel.text = formatter.string(from: NSNumber(value: amount))!
        self.view.addSubview(amountLabel)
        
        // 花費記錄列表
        myTableView = UITableView(frame: CGRect(x: 0, y: 105, width: fullsize.width, height: fullsize.height - 169) , style: .grouped)
        //myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.allowsSelection = true
        myTableView.backgroundColor = UIColor.black
        myTableView.separatorColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
        self.view.addSubview(myTableView)
        
        // 點選 cell 後的 UIView
        selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: fullsize.width, height: 44))
        selectedBackgroundView.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)

        // 底部新增記錄按鈕
        let addBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        addBtn.center = CGPoint(x: fullsize.width * 0.5, y: fullsize.height - 105)
        addBtn.addTarget(self, action: #selector(ViewController.addBtnAction), for: .touchUpInside)
        addBtn.setImage(UIImage(named:"add"), for: .normal)
        self.view.addSubview(addBtn)
    
    }

    override func viewWillAppear(_ animated: Bool) {
        let displayYearMonth = myUserDefaults.object(forKey: "displayYearMonth") as? String
        if displayYearMonth != nil && displayYearMonth != "" {
            myFormatter.dateFormat = "yyyy-MM"
            currentDate = myFormatter.date(from: displayYearMonth!)!
            
            myUserDefaults.set("", forKey: "displayYearMonth")
            myUserDefaults.synchronize()
        }
        
        self.updateRecordsList()
    }
    
// MARK: functional methods
    
    // 更新列表
    func updateRecordsList() {
        myFormatter.dateFormat = "yyyy-MM"
        let yearMonth = myFormatter.string(from: currentDate)
        if let mydb = db {
            days = []
            myRecords = [:]
            var total = 0.0
            
            let statement = mydb.fetch("records", cond: "yearMonth == '\(yearMonth)'", order: "createTime desc, id desc")
            while sqlite3_step(statement) == SQLITE_ROW{
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(cString: sqlite3_column_text(statement, 1))
                
                
                let amount = sqlite3_column_double(statement, 2)
                let createDate = String(cString: sqlite3_column_text(statement, 4))
                
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
            currentMonthLabel.text = myFormatter.string(from: currentDate)
        }

    }
    
    // 切換月份
    func updateCurrentDate(_ dateComponents :DateComponents) {
        let cal = Calendar.current
        let newDate = (cal as NSCalendar).date(byAdding: dateComponents, to: currentDate, options: NSCalendar.Options(rawValue: 0))
        
        currentDate = newDate!
        
        self.updateRecordsList()
    }

// MARK: Button actions

    // 前一個月
    func prevBtnAction() {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        self.updateCurrentDate(dateComponents)
    }
    
    // 後一個月
    func nextBtnAction() {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        self.updateCurrentDate(dateComponents)
    }
    
    // 前往[關於]頁面
    func settingsBtnAction() {
        self.navigationController?.pushViewController(MoreViewController(), animated: true)
    }
    
    // 前往[新增]頁面
    func addBtnAction() {
        myUserDefaults.set(0, forKey: "postID")
        myUserDefaults.synchronize()

        self.navigationController?.pushViewController(PostViewController(), animated: false)
    }

    
// MARK: UITableView Delegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = days[section]
        guard let records = myRecords[date] else {
            return 0
        }

        return records.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        cell!.textLabel?.textColor = UIColor.white
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)
        
        let date = days[indexPath.section]
        guard let records = myRecords[date] else {
            return
        }
        
        myUserDefaults.set(Int(records[indexPath.row]["id"]!), forKey: "postID")
        myUserDefaults.synchronize()
        
        self.navigationController?.pushViewController(PostViewController(), animated: true)
    }
    
    // 有幾個 section
    func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    // section 標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return days[section]
    }
    
    // section 標題 高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    // section footer 高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (days.count - 1) == section ? 60 : 3
    }
    
    // section header 樣式
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.init(red: 0.88, green: 0.83, blue: 0.73, alpha: 1)
    }


}

