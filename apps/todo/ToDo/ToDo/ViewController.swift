//
//  ViewController.swift
//  ToDo
//
//  Created by joe feng on 2016/6/14.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let myUserDefaults = NSUserDefaults.standardUserDefaults()
    var soundOpen :Bool = false
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let myEntityName = "Record"
    var coreDataConnect :CoreDataConnect!
    var myRecords :[Record]! = []
    var myTableView :UITableView!
    var myTextField :UITextField!
    var addBtn :UIButton!
    var addSound :AVAudioPlayer?
    var doneSound :AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 連接 Core Data
        coreDataConnect = CoreDataConnect(moc: self.moc)
        
        // 基本設定
        let fullsize = UIScreen.mainScreen().bounds.size
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "待辦事項"
        self.navigationController?.navigationBar.translucent = false
        
        // 是否開啟音效
        if let open = myUserDefaults.objectForKey("soundOpen") as? Int {
            soundOpen = open == 1 ? true : false
        }


        // 建立 UITableView
        myTableView = UITableView(frame: CGRect(x: 0, y: 44, width: fullsize.width, height: fullsize.height - 108), style: .Plain) // 20 + 44 + 44
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.allowsSelection = true
        self.view.addSubview(myTableView)


        // 導覽列右邊更多按鈕
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "more")!, style: .Plain, target: self, action: #selector(ViewController.moreBtnAction))
        
        
        // 新增輸入框
        myTextField = UITextField(frame: CGRect(x: 9, y: 5, width: fullsize.width - 54, height: 34))
        myTextField.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        myTextField.delegate = self
        myTextField.placeholder = "新增事項"
        myTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 34))
        myTextField.leftViewMode = .Always
        myTextField.returnKeyType = .Done
        self.view.addSubview(myTextField)

        // 新增按鈕
        addBtn = UIButton(type: .ContactAdd)
        addBtn.center = CGPoint(x: fullsize.width - 22, y: 22)
        addBtn.addTarget(self, action: #selector(ViewController.addBtnAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(addBtn)
    
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // 導覽列左邊編輯按鈕
        myTableView.setEditing(true, animated: false)
        self.editBtnAction()
        
        // 取得資料
        let selectResult = coreDataConnect.fetch(myEntityName, predicate: "done = false", sort: [["seq":false], ["id":false]], limit:nil)
        if let results = selectResult {
            myRecords = results
        }
        
        myTableView.reloadData()
        
        // 音效
        if soundOpen {
            let addSoundPath = NSBundle.mainBundle().pathForResource("bottle_pop_2", ofType: "wav")
            let doneSoundPath = NSBundle.mainBundle().pathForResource("woohoo", ofType: "wav")
            do {
                addSound = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(addSoundPath!))
                addSound!.numberOfLoops = 0

                doneSound = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(doneSoundPath!))
                doneSound!.numberOfLoops = 0
                
            } catch {
                print("error")
            }
        } else {
            addSound = nil
            doneSound = nil
        }
    
    }

    
// MARK: Button actions
    
    // 按下更多按鈕時執行動作的方法
    func moreBtnAction() {
        print("more")
    }

    // 按下編輯按鈕時執行動作的方法
    func editBtnAction() {
        myTableView.setEditing(!myTableView.editing, animated: true)
        if (!myTableView.editing) {
            // 顯示編輯按鈕
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(ViewController.editBtnAction))
            
            // 可以新增
            myTextField.userInteractionEnabled = true
            addBtn.enabled = true
            
        } else {
            // 顯示編輯完成按鈕
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(ViewController.editBtnAction))
            
            // 無法新增
            self.view.endEditing(true)
            myTextField.userInteractionEnabled = false
            addBtn.enabled = false
        }
    }
    
    // 按下新增按鈕時執行動作的方法
    func addBtnAction() {
        // 結束編輯 把鍵盤隱藏起來
        self.view.endEditing(true)
        
        let content = myTextField.text ?? ""
        
        if content != "" {
            addSound?.play()
            
            // 取得目前 seq 的最大值
            var seq = 100
            let selectResult = coreDataConnect.fetch(myEntityName, predicate: "done = false", sort: [["id":true]], limit: 1)
            if let results = selectResult {
                for result in results {
                    seq = Int((result.seq?.intValue)!) + 1
                }
            }

            // auto increment
            var id = 1
            if let idSeq = myUserDefaults.objectForKey("idSeq") as? Int {
                id = idSeq + 1
            }
            
            // insert
            let insertResult = coreDataConnect.insert(
                myEntityName, attributeInfo: [
                    "id" : "\(id)",
                    "content" : content,
                    "seq" : "\(seq)",
                    "done" : "false"
                ])

            if insertResult {
                print("新增資料成功")
                
                // 新增資料至陣列
                let newRecord = coreDataConnect.fetch(myEntityName, predicate: "id = \(id)", sort: nil, limit: 1)
                myRecords.insert(newRecord![0], atIndex: 0)
                
                // 新增 cell 在第一筆 row
                myTableView.beginUpdates()
                myTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
                myTableView.endUpdates()
                
                // 更新 auto increment
                myUserDefaults.setObject(id, forKey: "idSeq")
                myUserDefaults.synchronize()
                
                // 重設輸入框
                myTextField.text = ""

            }
        }
        
    }
    
    
// MARK: UITableView Delegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecords.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        // 顯示的內容
        cell.textLabel?.text = "\(myRecords[indexPath.row].content ?? "")"
        
        // 內容內容內容內容內容內容內容內容內容內容
        
        return cell
    }
    
    // 點選 cell 後執行的動作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)

        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let name = myRecords[indexPath.row].content
        print("選擇的是 \(name)")
        
        // 更新更新更新更新更新更新更新更新更新更新
    }
    
    // 各 cell 是否可以進入編輯狀態 及 左滑刪除
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 編輯狀態時 拖曳切換 cell 位置後執行動作的方法 (必須實作這個方法才會出現排序功能)
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        print("\(sourceIndexPath.row) to \(destinationIndexPath.row)")
        
        var tempArr:[Record] = []
        
        if(sourceIndexPath.row > destinationIndexPath.row) { // 排在後的往前移動
            for (index, value) in myRecords.enumerate() {
                if index < destinationIndexPath.row || index > sourceIndexPath.row {
                    tempArr.append(value)
                } else if index == destinationIndexPath.row {
                    tempArr.append(myRecords[sourceIndexPath.row])
                } else if index <= sourceIndexPath.row {
                    tempArr.append(myRecords[index - 1])
                }
            }
        } else if (sourceIndexPath.row < destinationIndexPath.row) { // 排在前的往後移動
            for (index, value) in myRecords.enumerate() {
                if index < sourceIndexPath.row || index > destinationIndexPath.row {
                    tempArr.append(value)
                } else if index < destinationIndexPath.row {
                    tempArr.append(myRecords[index + 1])
                } else if index == destinationIndexPath.row {
                    tempArr.append(myRecords[sourceIndexPath.row])
                }
            }
        } else {
            tempArr = myRecords
        }
        
        myRecords = tempArr
        self.updateRecordsSeq()
        
    }
    
    // 編輯狀態時 按下刪除 cell 後執行動作的方法 (另外必須實作這個方法才會出現左滑刪除功能)
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let id = myRecords[indexPath.row].id
        
        if editingStyle == .Delete {
            if coreDataConnect.delete(myEntityName, predicate: "id = \(id!)") {
                myRecords.removeAtIndex(indexPath.row)
                
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.endUpdates()
                
                print("刪除的是 \(id!)")
            }
        }
    }

    
// MARK: UITextFieldDelegate delegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.addBtnAction()
        
        return true
    }
    

// MARK: functional methods
    
    // 更新 Core Data 資料的排序
    func updateRecordsSeq() {
        var count = myRecords.count
        
        for record in myRecords {
            let result = coreDataConnect.update(myEntityName, predicate: "id = \(record.id!)", attributeInfo: ["seq":"\(count)"])
            if result {
                print("\(record.id!) : \(count)")
            } else {
                print("error")
            }
            count = count - 1
        }
    }
    
    
}

