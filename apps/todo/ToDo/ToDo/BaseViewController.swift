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
    let fullsize = UIScreen.main.bounds.size
    let myUserDefaults = UserDefaults.standard
    var soundOpen :Bool = false
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        coreDataConnect = CoreDataConnect(context: self.moc)
        
        // 基本設定
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 是否開啟音效
        if let open = myUserDefaults.object(forKey: "soundOpen") as? Int {
            soundOpen = open == 1 ? true : false
        }
        
        // 取得資料
        let selectResult = coreDataConnect.retrieve(myEntityName, predicate: "done = \(checkStatus ? "true" : "false")", sort: [["seq":false], ["id":false]], limit:nil)
        if let results = selectResult {
            myRecords = results as? [Record]
        }
        
        myTableView.reloadData()
        
        // 音效
        if soundOpen {
            let addSoundPath = Bundle.main.path(forResource: "bottle_pop_3", ofType: "wav")
            let doneSoundPath = Bundle.main.path(forResource: (checkStatus ? "what-2" : "woohoo"), ofType: "wav")
            let deleteSoundPath = Bundle.main.path(forResource: "cutting-paper-2", ofType: "mp3")
            do {
                addSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: addSoundPath!))
                addSound!.numberOfLoops = 0
                
                doneSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: doneSoundPath!))
                doneSound!.numberOfLoops = 0
                
                deleteSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: deleteSoundPath!))
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

    
// MARK: UITableView Delegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecords.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
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
        checkBtn.tag = cehckTagTemp + (myRecords[indexPath.row].id ?? 0).intValue
        checkBtn.addTarget(self, action: #selector(ViewController.checkBtnAction), for: .touchUpInside)
        checkBtn.setImage(UIImage(named:(checkStatus ? "check" : "checkbox")), for: .normal)
        cell.contentView.addSubview(checkBtn)
        
        return cell
    }

    // 點選 cell 後執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
        // 取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 各 cell 是否可以進入編輯狀態 及 左滑刪除
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 編輯狀態時 按下刪除 cell 後執行動作的方法 (另外必須實作這個方法才會出現左滑刪除功能)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let id = myRecords[indexPath.row].id
        
        if editingStyle == .delete {
            if coreDataConnect.delete(myEntityName, predicate: "id = \(id!)") {
                deleteSound?.play()
                
                myRecords.remove(at: indexPath.row)
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                
                print("刪除的是 \(id!)")
            }
        }
    }

    
// MARK: Button actions
    
    // 按下完成事項按鈕執行動作的方法
    @objc func checkBtnAction(_ sender: UIButton) {
        let id = sender.tag - cehckTagTemp
        if id != 0 {
            var index = -1
            for (i, record) in myRecords.enumerated() {
                if (record.id as! Int) == id {
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
                    sender.setImage(UIImage(named:(checkStatus ? "checkbox" : "check")), for: .normal)
                    
                    // 從陣列中移除
                    myRecords.remove(at: index)
                    
                    // 從 UITableView 中移除
                    myTableView.beginUpdates()
                    myTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    myTableView.endUpdates()
                } else {
                    print("error")
                }
            }
        }
    }
    
}
