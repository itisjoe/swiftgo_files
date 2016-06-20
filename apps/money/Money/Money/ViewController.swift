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
    
    var days = ["2016-06-01","2016-06-02","2016-06-01"]
    var myRecords = [
        "2016-06-01":"早餐","2016-06-02":"草餐餐","2016-06-03":"吃吃吃"
    ]
    
    var myScrollView :UIScrollView!
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
        self.view.backgroundColor = UIColor.blackColor()
        self.navigationController?.navigationBar.translucent = false
        
        // 導覽列右邊設定按鈕
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings")!, style: .Plain, target: self, action: #selector(ViewController.settingsBtnAction))
        
        // 基底的 UIScrollView
        let myScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: fullsize.width, height: fullsize.height - 64))
        myScrollView.contentSize = CGSize(width: fullsize.width, height: fullsize.height * 2)
        self.view.addSubview(myScrollView)
        
        // 目前年月
        currentMonthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullsize.width * 0.6, height: 50))
        currentMonthLabel.center = CGPoint(x: fullsize.width * 0.5, y: 35)
        currentMonthLabel.textColor = UIColor.whiteColor()
        currentMonthLabel.text = "2016-06"
        currentMonthLabel.textAlignment = .Center
        currentMonthLabel.font = UIFont(name: "Helvetica Light", size: 40.0)
        myScrollView.addSubview(currentMonthLabel)
        
        // 前一月份按鈕
        prevBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        prevBtn.center = CGPoint(x: fullsize.width * 0.15, y: 35)
        prevBtn.setImage(UIImage(named: "prev"), forState: .Normal)
        prevBtn.addTarget(self, action: #selector(ViewController.prevBtnAction), forControlEvents: .TouchUpInside)
        myScrollView.addSubview(prevBtn)
        
        // 後一月份按鈕
        nextBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        nextBtn.center = CGPoint(x: fullsize.width * 0.85, y: 35)
        nextBtn.setImage(UIImage(named: "next"), forState: .Normal)
        nextBtn.addTarget(self, action: #selector(ViewController.nextBtnAction), forControlEvents: .TouchUpInside)
        myScrollView.addSubview(nextBtn)
        
        // 總金額
        let dollarSignLabel = UILabel(frame: CGRect(x: 20, y: 70, width: 50, height: 30))
        dollarSignLabel.font = UIFont(name: "Helvetica Light", size: 30.0)
        dollarSignLabel.textColor = UIColor.whiteColor()
        dollarSignLabel.text = "$"
        myScrollView.addSubview(dollarSignLabel)
        let amount = 12300
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        amountLabel = UILabel(frame: CGRect(x: 20, y: 70, width: fullsize.width - 40, height: 30))
        amountLabel.font = UIFont(name: "Helvetica Light", size: 30.0)
        amountLabel.textAlignment = .Right
        amountLabel.textColor = UIColor.whiteColor()
        amountLabel.text = "\(formatter.stringFromNumber(amount)!)"
        myScrollView.addSubview(amountLabel)
        
        // 花費記錄列表
        myTableView = UITableView(frame: CGRect(x: 0, y: 105, width: fullsize.width, height: fullsize.height) , style: .Grouped)
        //myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.allowsSelection = true
        myTableView.backgroundColor = UIColor.blackColor()
        myTableView.separatorColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
        myScrollView.addSubview(myTableView)
        
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
    

// MARK: Button actions

    func prevBtnAction() {
        print("prevBtnAction")
    }
    
    func nextBtnAction() {
        print("nextBtnAction")
    }
    
    func settingsBtnAction() {
        print("settingsBtnAction")
        //self.navigationController?.pushViewController(MoreViewController(), animated: true)
    }
    
    func addBtnAction() {
        print("addBtnAction")
        //self.navigationController?.pushViewController(AddViewController(), animated: true)
    }

    
// MARK: UITableView Delegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let date = days[section]
        
//        guard let records = myRecords[date] else {
//            return 0
//        }

        return 1
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
        cell!.detailTextLabel?.text = "3,092"
        
        cell!.selectedBackgroundView = selectedBackgroundView
        
        
        // 顯示的內容
        let date = days[indexPath.section]

        guard let records = myRecords[date] else {
            return cell!
        }

        cell!.textLabel?.text = records
        
        return cell!
    }
    
    // 點選 cell 後執行的動作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
        return 30
    }

    // section footer 高度
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    // section header 樣式
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.init(red: 0.88, green: 0.83, blue: 0.73, alpha: 1)
    }


}

