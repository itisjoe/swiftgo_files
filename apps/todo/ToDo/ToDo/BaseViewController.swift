//
//  BaseViewController.swift
//  ToDo
//
//  Created by joe feng on 2016/6/17.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import AVFoundation

class BaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let fullsize = UIScreen.mainScreen().bounds.size
    let myUserDefaults = NSUserDefaults.standardUserDefaults()
    var soundOpen :Bool = false
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let myEntityName = "Record"
    var coreDataConnect :CoreDataConnect!
    var myRecords :[Record]! = []
    var myTableView :UITableView!
    var addSound :AVAudioPlayer?
    var doneSound :AVAudioPlayer?
    var deleteSound :AVAudioPlayer?
    var checkStatus = false
    let cehckTagTemp = 1000

    override func viewDidLoad() {
        super.viewDidLoad()

        // 連接 Core Data
        coreDataConnect = CoreDataConnect(moc: self.moc)
        
        // 基本設定
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false

    }
    
    override func viewWillAppear(animated: Bool) {
        // 是否開啟音效
        if let open = myUserDefaults.objectForKey("soundOpen") as? Int {
            soundOpen = open == 1 ? true : false
        }
        
        // 取得資料
        let selectResult = coreDataConnect.fetch(myEntityName, predicate: "done = \(checkStatus ? "true" : "false")", sort: [["seq":false], ["id":false]], limit:nil)
        if let results = selectResult {
            myRecords = results
        }
        
        myTableView.reloadData()
        
        // 音效
        if soundOpen {
            let addSoundPath = NSBundle.mainBundle().pathForResource("bottle_pop_3", ofType: "wav")
            let doneSoundPath = NSBundle.mainBundle().pathForResource((checkStatus ? "what-2" : "woohoo"), ofType: "wav")
            let deleteSoundPath = NSBundle.mainBundle().pathForResource("cutting-paper-2", ofType: "mp3")
            do {
                addSound = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(addSoundPath!))
                addSound!.numberOfLoops = 0
                
                doneSound = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(doneSoundPath!))
                doneSound!.numberOfLoops = 0
                
                deleteSound = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(deleteSoundPath!))
                deleteSound!.numberOfLoops = 0
                
            } catch {
                print("error")
            }
        } else {
            addSound = nil
            doneSound = nil
            deleteSound = nil
        }
    }
    

// MARK: Button actions
    
    // 按下完成事項按鈕執行動作的方法
    func checkBtnAction(sender: UIButton) {
        let id = sender.tag - cehckTagTemp
        if id != 0 {
            var index = -1
            for (i, record) in myRecords.enumerate() {
                if record.id == id {
                    index = i
                    break
                }
            }
            
            if index != -1 {
                // 設置 Core Data
                let result = coreDataConnect.update(myEntityName, predicate: "id = \(id)", attributeInfo: ["done":(checkStatus ? "false" : "true")])
                if result {
                    // 音效
                    doneSound?.play()
                    
                    // 打勾
                    sender.setImage(UIImage(named:(checkStatus ? "checkbox" : "check")), forState: .Normal)
                    
                    // 從陣列中移除
                    myRecords.removeAtIndex(index)
                    
                    // 從 UITableView 中移除
                    myTableView.beginUpdates()
                    myTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Fade)
                    myTableView.endUpdates()
                } else {
                    print("error")
                }
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
        
        // 移除舊的按鈕
        for view in cell.contentView.subviews {
            if let v = view as? UIButton {
                v.removeFromSuperview()
            }
        }

        // 點選完成事項
        let checkBtn = UIButton(frame: CGRect(x: Double(fullsize.width) - 42, y: 2, width: 40, height: 40))
        checkBtn.tag = cehckTagTemp + Int(myRecords[indexPath.row].id ?? 0)
        checkBtn.addTarget(self, action: #selector(ViewController.checkBtnAction), forControlEvents: .TouchUpInside)
        checkBtn.setImage(UIImage(named:(checkStatus ? "check" : "checkbox")), forState: .Normal)
        cell.contentView.addSubview(checkBtn)
        
        return cell
    }

    // 點選 cell 後執行的動作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        
        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // 各 cell 是否可以進入編輯狀態 及 左滑刪除
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 編輯狀態時 按下刪除 cell 後執行動作的方法 (另外必須實作這個方法才會出現左滑刪除功能)
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let id = myRecords[indexPath.row].id
        
        if editingStyle == .Delete {
            if coreDataConnect.delete(myEntityName, predicate: "id = \(id!)") {
                deleteSound?.play()
                
                myRecords.removeAtIndex(indexPath.row)
                
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.endUpdates()
                
                print("刪除的是 \(id!)")
            }
        }
    }

    
}
