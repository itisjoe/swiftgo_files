//
//  ViewController.swift
//  ExUITextField
//
//  Created by joe feng on 2016/5/13.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 使用 UITextField(frame:) 建立一個 UITextField
        let myTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        // 尚未輸入時的預設顯示提示文字
        myTextField.placeholder = "請輸入文字"
        
        // 輸入框的樣式 這邊選擇圓角樣式
        myTextField.borderStyle = .RoundedRect
        
        // 輸入框右邊顯示清除按鈕時機 這邊選擇當編輯時顯示
        myTextField.clearButtonMode = .WhileEditing
        
        // 輸入框適用的鍵盤 這邊選擇 適用輸入 Email 的鍵盤(會有 @ 跟 . 可供輸入)
        myTextField.keyboardType = .EmailAddress
        
        // 鍵盤上的 return 鍵樣式 這邊選擇 Done
        myTextField.returnKeyType = .Done
        
        // 輸入文字的顏色
        myTextField.textColor = UIColor.whiteColor()
        
        // UITextField 的背景顏色
        myTextField.backgroundColor = UIColor.lightGrayColor()
        
        // 委任模式( Delegation )所要實作方法的對象
        // 這邊就是交由 self 也就是 ViewController 本身
        myTextField.delegate = self

        // 取得螢幕的尺寸
        let fullScreenSize = UIScreen.mainScreen().bounds.size
        
        // 設置於畫面的中間偏上位置
        myTextField.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.3)
        
        // 加入畫面
        self.view.addSubview(myTextField)
    
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // 結束編輯 把鍵盤隱藏起來
        self.view.endEditing(true)
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

