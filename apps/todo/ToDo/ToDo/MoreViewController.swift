//
//  MoreViewController.swift
//  ToDo
//
//  Created by joe feng on 2016/6/17.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let fullSize :CGSize = UIScreen.main.bounds.size
    let myUserDefaults = UserDefaults.standard
    var soundOpen:Int? = 0
    var mySwitch :UISwitch!
    var myTableView :UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "關於"
        
        // 建立 UITableView
        self.myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.fullSize.width, height: self.fullSize.height - 64), style: .grouped)
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.allowsSelection = true
        self.view.addSubview(self.myTableView)
        
        // 音效開關
        mySwitch = UISwitch()
        soundOpen = myUserDefaults.object(forKey: "soundOpen") as? Int
        mySwitch.isOn = soundOpen == 1 ? true : false
        mySwitch.addTarget(self, action: #selector(MoreViewController.onSwitchChange), for: .valueChanged)
    }

    
// MARK: Button actions

    func onSwitchChange(_ sender :UISwitch) {
        myUserDefaults.set((sender.isOn ? 1 : 0 ), forKey: "soundOpen")
        myUserDefaults.synchronize()
    }
    
    func goFB() {
        let requestUrl = URL(string: "https://www.facebook.com/1640636382849659")
        UIApplication.shared.open(requestUrl!, options: ["":""], completionHandler: nil)
    }
    
    func goSoundSource() {
        let requestUrl = URL(string: "http://www.pacdv.com/sounds")
        UIApplication.shared.open(requestUrl!, options: ["":""], completionHandler: nil)
    }

    
// MARK: UITableViewDelegate methods
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        cell.accessoryType = .none
        
        if indexPath.section == 0 { // 更多 - 已完成事項
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "已完成事項"

        } else if indexPath.section == 1 { // 設定 - 音效 switch
            cell.textLabel?.text = "音效"
            cell.accessoryView = mySwitch

        } else if indexPath.section == 2 { // 支援 - fb
            let fbButton = UIButton(frame: CGRect(x: 15, y: 0, width: fullSize.width, height: 40))
            fbButton.addTarget(self, action: #selector(MoreViewController.goFB), for: .touchUpInside)
            fbButton.setTitle("在 Facebook 上與我們聯絡", for: .normal)
            fbButton.setTitleColor(UIColor.black, for: .normal)
            fbButton.contentHorizontalAlignment = .left
            cell.contentView.addSubview(fbButton)

        } else if indexPath.section == 3 { // 來源 - 音效
            let button = UIButton(frame: CGRect(x: 15, y: 0, width: fullSize.width, height: 40))
            button.addTarget(self, action: #selector(MoreViewController.goSoundSource), for: .touchUpInside)
            button.setTitle("音效： PacDV", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.contentHorizontalAlignment = .left
            cell.contentView.addSubview(button)
        }
        
        return cell
    }
    
    // 點選 cell 後執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            self.navigationController?.pushViewController(ChechedRecordsViewController(), animated: true)
        }
    }
    
    // 有幾組 section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // 每個 section 的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = "來源"
        if section == 0 {
            title = "更多"
        } else if section == 1 {
            title = "設定"
        } else if section == 2 {
            title = "支援"
        }
        
        return title
    }

}
