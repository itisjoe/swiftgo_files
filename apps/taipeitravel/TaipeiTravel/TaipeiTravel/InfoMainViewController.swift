//
//  InfoMainViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/6.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class InfoMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    let fullSize :CGSize = UIScreen.main.bounds.size
    var myTableView :UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 樣式
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "關於"
        
        // 建立 UITableView 並設置原點及尺寸
        self.myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.fullSize.width, height: self.fullSize.height - 113), style: .grouped)
        
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

    @objc func goFB() {
        let requestUrl = URL(string: "https://www.facebook.com/swiftgogogo")
        UIApplication.shared.open(requestUrl!)
    }

    @objc func goIconSource() {
        let requestUrl = URL(string: "https://www.flaticon.com/")
        UIApplication.shared.open(requestUrl!)
    }

    @objc func goDataSource() {
        let requestUrl = URL(string: "https://data.taipei/")
        UIApplication.shared.open(requestUrl!)
    }

    
// MARK: UITableViewDelegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1) ? 2 : 1
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let fbButton = UIButton(frame: CGRect(x: 15, y: 0, width: fullSize.width, height: 40))
                fbButton.addTarget(self, action: #selector(InfoMainViewController.goFB), for: .touchUpInside)
                fbButton.setTitle("在 Facebook 上與我們聯絡", for: .normal)
                fbButton.setTitleColor(UIColor.black, for: .normal)
                fbButton.contentHorizontalAlignment = .left
                cell.contentView.addSubview(fbButton)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let button = UIButton(frame: CGRect(x: 15, y: 0, width: fullSize.width, height: 40))
                button.addTarget(self, action: #selector(InfoMainViewController.goDataSource), for: .touchUpInside)
                button.setTitle("資料： 臺北市政府資料開放平台", for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                button.contentHorizontalAlignment = .left
                cell.contentView.addSubview(button)
            } else {
                let button = UIButton(frame: CGRect(x: 15, y: 0, width: fullSize.width, height: 40))
                button.addTarget(self, action: #selector(InfoMainViewController.goIconSource), for: .touchUpInside)
                button.setTitle("圖示： FLATICON", for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                button.contentHorizontalAlignment = .left
                cell.contentView.addSubview(button)
            }
        } else if indexPath.section == 2 {
            cell.textLabel?.text = "當開啟定位服務時，顯示資料僅會列出距離目前定位位置較近的地點。"
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
        }
        
        return cell
    }
    
    // 點選 cell 後執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // 有幾組 section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // 每個 section 的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = "說明"
        if section == 0 {
            title = "支援"
        } else if section == 1 {
            title = "來源"
        }

        return title
    }
    
    // 設置 cell 的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(44.0)
        
        if indexPath.section == 2 {
            height = 120.0
        }
        
        return height
    }
    
}
