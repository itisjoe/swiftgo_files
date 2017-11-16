//
//  ViewController.swift
//  ExUISearchController
//
//  Created by joe feng on 2016/5/21.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tableView: UITableView!
    var searchController: UISearchController!
    
    let cities = [
        "臺北市","新北市","桃園市","臺中市","臺南市","高雄市","基隆市","新竹市","嘉義市","新竹縣",
        "苗栗縣","彰化縣","南投縣","雲林縣","嘉義縣","屏東縣","宜蘭縣","花蓮縣","臺東縣","澎湖縣",]

    var searchArr: [String] = [String](){
        didSet {
            // 重設 searchArr 後重整 tableView
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 取得螢幕的尺寸
        let fullScreenSize = UIScreen.main.bounds.size
        
        // 建立 UITableView
        tableView = UITableView(frame: CGRect(x: 0, y: 20, width: fullScreenSize.width, height: fullScreenSize.height - 20), style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    
        
        // 建立 UISearchController 並設置搜尋控制器為 nil
        searchController = UISearchController(searchResultsController: nil)
        
        // 將更新搜尋結果的對象設為 self
        searchController.searchResultsUpdater = self
        
        // 搜尋時是否隱藏 NavigationBar
        // 這個範例沒有使用 NavigationBar 所以設置什麼沒有影響
        searchController.hidesNavigationBarDuringPresentation = false
        
        // 搜尋時是否使用燈箱效果 (會將畫面變暗以集中搜尋焦點)
        searchController.dimsBackgroundDuringPresentation = false
        
        // 搜尋框的樣式
        searchController.searchBar.searchBarStyle = .prominent
        
        // 設置搜尋框的尺寸為自適應
        // 因為會擺在 tableView 的 header
        // 所以尺寸會與 tableView 的 header 一樣
        searchController.searchBar.sizeToFit()
        
        // 將搜尋框擺在 tableView 的 header
        self.tableView.tableHeaderView = searchController.searchBar
        
    }

}

