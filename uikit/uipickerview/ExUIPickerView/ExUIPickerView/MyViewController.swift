//
//  MyViewController.swift
//  ExUIPickerView
//
//  Created by joe feng on 2016/5/18.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class MyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let week = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    let meals = ["早餐","午餐","晚餐","宵夜"]
    var whatDay = "星期日"
    var whatMeal = "早餐"

    // UIPickerViewDataSource 必須實作的方法：UIPickerView 有幾列可以選擇
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // UIPickerViewDataSource 必須實作的方法：UIPickerView 各列有多少行資料
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 設置第一列時
        if component == 0 {
            // 返回陣列 week 的成員數量
            return week.count
        }
        
        // 否則就是設置第二列
        // 返回陣列 meals 的成員數量
        return meals.count
    }
    
    // UIPickerView 每個選項顯示的資料
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 設置第一列時
        if component == 0 {
            // 設置為陣列 week 的第 row 項資料
            return week[row]
        }

        // 否則就是設置第二列
        // 設置為陣列 meals 的第 row 項資料
        return meals[row]
    }
    
    // UIPickerView 改變選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 改變第一列時
        if component == 0 {
            // whatDay 設置為陣列 week 的第 row 項資料
            whatDay = week[row]
        } else {
            // 否則就是改變第二列
            // whatMeal 設置為陣列 meals 的第 row 項資料
            whatMeal = meals[row]
        }
        
        // 將改變的結果印出來
        print("選擇的是 \(whatDay) ， \(whatMeal)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
