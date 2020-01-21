//
//  ViewController.swift
//  ToDo
//
//  Created by joe feng on 2016/6/14.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    var myTextField :UITextField!
    var addBtn :UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "待辦事項"
        checkStatus = false

        // 建立 UITableView
        myTableView = UITableView(frame: CGRect(x: 0, y: 44, width: fullsize.width, height: fullsize.height - 108), style: .plain) // 108 = 20 + 44 + 44
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.allowsSelection = true
        self.view.addSubview(myTableView)

        // 導覽列右邊更多按鈕
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more")!, style: .plain, target: self, action: #selector(ViewController.moreBtnAction))
        
        // 新增輸入框
        myTextField = UITextField(frame: CGRect(x: 9, y: 5, width: fullsize.width - 54, height: 34))
        myTextField.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        myTextField.delegate = self
        myTextField.placeholder = "新增事項"
        myTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 34))
        myTextField.leftViewMode = .always
        myTextField.returnKeyType = .done
        self.view.addSubview(myTextField)

        // 新增按鈕
        addBtn = UIButton(type: .contactAdd)
        addBtn.center = CGPoint(x: fullsize.width - 22, y: 22)
        addBtn.addTarget(self, action: #selector(ViewController.addBtnAction), for: .touchUpInside)
        self.view.addSubview(addBtn)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // 進入 非 編輯模式
        myTableView.setEditing(true, animated: false)
        self.editBtnAction()

    }

    
// MARK: Button actions
    
    // 按下更多按鈕時執行動作的方法
    @objc func moreBtnAction() {
        self.navigationController?.pushViewController(MoreViewController(), animated: true)
    }

    // 按下編輯按鈕時執行動作的方法
    @objc func editBtnAction() {
        myTableView.setEditing(!myTableView.isEditing, animated: true)
        if (!myTableView.isEditing) {
            // 顯示編輯按鈕
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain , target: self, action: #selector(ViewController.editBtnAction))
            
            // 可以新增
            myTextField.isUserInteractionEnabled = true
            addBtn.isEnabled = true
            
            // 顯示完成按鈕
            for record in myRecords {
                if let id = record.id {
                    let btn = self.view.viewWithTag(cehckTagTemp + id.intValue) as? UIButton
                    btn?.isHidden = false
                }
            }
            
        } else {
            // 顯示編輯完成按鈕
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "完成", style: .plain , target: self, action: #selector(ViewController.editBtnAction))
            
            // 無法新增
            self.view.endEditing(true)
            myTextField.isUserInteractionEnabled = false
            addBtn.isEnabled = false
            
            // 隱藏完成按鈕
            for record in myRecords {
                if let id = record.id {
                    let btn = self.view.viewWithTag(cehckTagTemp + id.intValue) as? UIButton
                    btn?.isHidden = true
                }
            }

        }
    }
    
    // 按下新增按鈕時執行動作的方法
    @objc func addBtnAction() {
        // 結束編輯 把鍵盤隱藏起來
        self.view.endEditing(true)
        
        let content = myTextField.text ?? ""
        
        if content != "" {
            addSound?.play()
            
            // 取得目前 seq 的最大值
            var seq = 100
            let selectResult = coreDataConnect.retrieve(myEntityName, predicate: "done = false", sort: [["id":true]], limit: 1)
            if let results = selectResult {
                for result in results {
                    seq = (result.value(forKey: "seq") as! Int) + 1
                }
            }

            // auto increment
            var id = 1
            if let idSeq = myUserDefaults.object(forKey: "idSeq") as? Int {
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
                let newRecord = coreDataConnect.retrieve(myEntityName, predicate: "id = \(id)", sort: nil, limit: 1)
                
                myRecords.insert((newRecord![0] as! Record), at: 0)
                
                // 新增 cell 在第一筆 row
                myTableView.beginUpdates()
                myTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                myTableView.endUpdates()
                
                // 更新 auto increment
                myUserDefaults.set(id, forKey: "idSeq")
                myUserDefaults.synchronize()
                
                // 重設輸入框
                myTextField.text = ""

            }
        }
        
    }
    

// MARK: UITableView Delegate methods
    
    // 點選 cell 後執行的動作
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        self.updateRecordContent(indexPath)

    }

    // 編輯狀態時 拖曳切換 cell 位置後執行動作的方法 (必須實作這個方法才會出現排序功能)
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("\(sourceIndexPath.row) to \(destinationIndexPath.row)")
        
        var tempArr:[Record] = []
        
        if(sourceIndexPath.row > destinationIndexPath.row) { // 排在後的往前移動
            for (index, value) in myRecords.enumerated() {
                if index < destinationIndexPath.row || index > sourceIndexPath.row {
                    tempArr.append(value)
                } else if index == destinationIndexPath.row {
                    tempArr.append(myRecords[sourceIndexPath.row])
                } else if index <= sourceIndexPath.row {
                    tempArr.append(myRecords[index - 1])
                }
            }
        } else if (sourceIndexPath.row < destinationIndexPath.row) { // 排在前的往後移動
            for (index, value) in myRecords.enumerated() {
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

    
// MARK: UITextFieldDelegate delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.addBtnAction()
        
        return true
    }
    

// MARK: functional methods
    
    // 更新事項內容
    func updateRecordContent(_ indexPath :IndexPath) {
        let name = myRecords[indexPath.row].content!
        let id = myRecords[indexPath.row].id!.intValue
        
        // 更新事項
        let updateAlertController = UIAlertController(title: "更新", message: nil, preferredStyle: .alert)
        
        // 建立輸入框
        updateAlertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.text = name
            textField.placeholder = "更新事項"
        }
        
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        updateAlertController.addAction(cancelAction)
        
        // 建立[更新]按鈕
        let okAction = UIAlertAction(title: "更新", style: UIAlertAction.Style.default) {
            (action: UIAlertAction!) -> Void in
            let content = (updateAlertController.textFields?.first)! as UITextField
            
            let result = self.coreDataConnect.update(self.myEntityName, predicate: "id = \(id)", attributeInfo: ["content":"\(content.text!)"])
            if result {
                let newRecord = self.coreDataConnect.retrieve(self.myEntityName, predicate: "id = \(id)", sort: nil, limit: 1)

                self.myRecords[indexPath.row] = newRecord![0] as! Record
                self.myTableView.reloadData()
            } else {
                print("error")
            }
        }
        updateAlertController.addAction(okAction)
        
        // 顯示提示框
        self.present(updateAlertController, animated: true, completion: nil)
    }
    
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

