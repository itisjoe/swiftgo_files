//
//  ViewControllerExtensions.swift
//  ExUISearchController
//
//  Created by joe feng on 2016/5/21.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchController.active) {
            return self.searchArr.count
        } else {
            return self.cities.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if (self.searchController.active) {
            cell.textLabel?.text = self.searchArr[indexPath.row]
            return cell
        } else {
            cell.textLabel?.text = self.cities[indexPath.row]
            return cell
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (self.searchController.active) {
            print("你選擇的是 \(self.searchArr[indexPath.row])")
        } else {
            print("你選擇的是 \(self.cities[indexPath.row])")
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController){
        // 取得搜尋文字
        guard let searchText = searchController.searchBar.text else {
            return
        }
    
        // 使用陣列的 filter() 方法篩選資料
        self.searchArr = self.cities.filter({ (city) -> Bool in
            // 將文字轉成 NSString 型別
            let cityText:NSString = city
            
            // 比對這筆資訊有沒有包含要搜尋的文字
            return (cityText.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
    }
}

