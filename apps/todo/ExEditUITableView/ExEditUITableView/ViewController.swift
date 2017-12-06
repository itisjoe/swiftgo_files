//
//  ViewController.swift
//  ExEditUITableView
//
//  Created by joe feng on 2016/6/15.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var myTableView :UITableView!
    var info = ["林書豪","陳信安","陳偉殷","王建民","陳金鋒","林智勝"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 基本設定
        let fullsize = UIScreen.main.bounds.size
        self.view.backgroundColor = UIColor.white
        self.title = "編輯模式"
        self.navigationController!.navigationBar.isTranslucent = false

        
        // 建立 UITableView
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: fullsize.width, height: fullsize.height - 64), style: .plain)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.allowsSelection = true
        self.view.addSubview(myTableView)
        
        
        // 導覽列左邊及右邊按鈕 編輯 & 新增
        myTableView.setEditing(true, animated: false)
        self.editBtnAction()

    }
    
    // 按下編輯按鈕時執行動作的方法
    @objc func editBtnAction() {
        myTableView.setEditing(!myTableView.isEditing, animated: true)
        if (!myTableView.isEditing) {
            // 顯示編輯按鈕
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ViewController.editBtnAction))

            // 顯示新增按鈕
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.addBtnAction))
        } else {
            // 顯示編輯完成按鈕
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.editBtnAction))
            
            // 隱藏新增按鈕
            self.navigationItem.rightBarButtonItem = nil
        }
    }

    
    // 按下新增按鈕時執行動作的方法
    @objc func addBtnAction() {
        print("新增一筆資料")
        info.insert("new row", at: 0)
        
        // 新增 cell 在第一筆 row
        myTableView.beginUpdates()
        myTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        myTableView.endUpdates()
    }

    
// MARK: UITableView Delegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        // 顯示的內容
        if let myLabel = cell.textLabel {
            myLabel.text = "\(info[indexPath.row])"
        }
        
        return cell
    }

    // 點選 cell 後執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)
        
        let name = info[indexPath.row]
        print("選擇的是 \(name)")
    }
    
    // 各 cell 是否可以進入編輯狀態 及 左滑刪除
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 編輯狀態時 拖曳切換 cell 位置後執行動作的方法 (必須實作這個方法才會出現排序功能)
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("\(sourceIndexPath.row) to \(destinationIndexPath.row)")
        
        var tempArr:[String] = []
        
        if(sourceIndexPath.row > destinationIndexPath.row) { // 排在後的往前移動
            for (index, value) in info.enumerated() {
                if index < destinationIndexPath.row || index > sourceIndexPath.row {
                    tempArr.append(value)
                } else if index == destinationIndexPath.row {
                    tempArr.append(info[sourceIndexPath.row])
                } else if index <= sourceIndexPath.row {
                    tempArr.append(info[index - 1])
                }
            }
        } else if (sourceIndexPath.row < destinationIndexPath.row) { // 排在前的往後移動
            for (index, value) in info.enumerated() {
                if index < sourceIndexPath.row || index > destinationIndexPath.row {
                    tempArr.append(value)
                } else if index < destinationIndexPath.row {
                    tempArr.append(info[index + 1])
                } else if index == destinationIndexPath.row {
                    tempArr.append(info[sourceIndexPath.row])
                }
            }
        } else {
            tempArr = info
        }
        
        info = tempArr
        print(info)
        
    }
    
    // 編輯狀態時 按下刪除 cell 後執行動作的方法 (另外必須實作這個方法才會出現左滑刪除功能)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let name = info[indexPath.row]
        
        if editingStyle == .delete {
            info.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()

            print("刪除的是 \(name)")
        }

    }

}

