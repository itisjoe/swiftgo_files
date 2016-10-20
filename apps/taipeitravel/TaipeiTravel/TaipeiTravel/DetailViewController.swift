//
//  DetailViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/7.
//  Copyright © 2016年 hsin. All rights reserved.
//
import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let fullSize :CGSize = UIScreen.main.bounds.size
    let myUserDefaults :UserDefaults = UserDefaults.standard
    var fetchType :String = ""
    var info :[String:AnyObject]! = nil
    var detail :[String] = []
    var hasMap :Bool = false
    var myTableView :UITableView!
    var selectedRowIndex :Int = -1
    var rowHeight :CGFloat = 88.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 樣式
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 建立 UITableView 並設置原點及尺寸
        self.myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.fullSize.width, height: self.fullSize.height - 113), style: .plain)
        
        // 註冊重複使用的 cell
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // 設置委任對象
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        // 是否可以點選 cell
        self.myTableView.allowsSelection = true
        
        // 加入到畫面中
        self.view.addSubview(self.myTableView)
        
    }
    
    
// MARK: UITableViewDelegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasMap ? 6 : 5
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        cell.accessoryType = .none
        
        if self.hasMap {
            cell.textLabel?.text = self.detail[indexPath.row] 
            if indexPath.row == 0 {
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "類型：" + (cell.textLabel?.text)!
            }
        } else {
            cell.textLabel?.text = self.detail[indexPath.row + 1] 
            if indexPath.row == 0 {
                cell.textLabel?.text = "類型：" + (cell.textLabel?.text)!
            }
        }
        
        if indexPath.row > (self.hasMap ? 1 : 0) {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
        }
        
        return cell
    }
    
    // 點選 cell 後執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.hasMap && indexPath.row == 0 {
            let viewController = MapViewController()
            viewController.info = self.info
            viewController.fetchType = self.fetchType
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let cell = myTableView.cellForRow(at: indexPath)
            let label = cell?.textLabel
            if indexPath.row == self.selectedRowIndex {
                self.rowHeight = 88.0
                self.selectedRowIndex = -1
            } else {
                label?.preferredMaxLayoutWidth = fullSize.width * 0.9
                let intrinsicSize = label?.intrinsicContentSize
                self.rowHeight = (intrinsicSize?.height)!
                
                self.selectedRowIndex = indexPath.row
            }
            myTableView.beginUpdates()
            myTableView.endUpdates()
        }
    }
    
    // 設置 cell 的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(44.0)
        
        if (self.hasMap && indexPath.row >= 2) || (!self.hasMap && indexPath.row >= 1) {
            height = 2.0 * height
        }
        
        if indexPath.row == self.selectedRowIndex {
            height = max(height, self.rowHeight + 5)
        }
        
        return height
    }
    
}
