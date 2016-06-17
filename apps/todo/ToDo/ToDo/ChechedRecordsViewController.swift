//
//  ChechedRecordsViewController.swift
//  ToDo
//
//  Created by joe feng on 2016/6/17.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ChechedRecordsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "已完成事項"
        self.automaticallyAdjustsScrollViewInsets = false
        checkStatus = true
        
        // 建立 UITableView
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: fullsize.width, height: fullsize.height - 64), style: .Plain)
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.allowsSelection = true
        self.view.addSubview(myTableView)
        
    }

}
