//
//  ViewController.swift
//  ExNSUserDefaults
//
//  Created by joe feng on 2016/5/26.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    var myTextField: UITextField!
    var myUserDefaults :NSUserDefaults!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 取得螢幕的尺寸
        let fullSize = UIScreen.mainScreen().bounds.size

        // 設置底色
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 取得儲存的預設資料
        myUserDefaults = NSUserDefaults.standardUserDefaults()

        // 設置導覽列內容
        self.title = "首頁"
        self.navigationController?.navigationBar.translucent = false
        let rightButton = UIBarButtonItem(title:"顯示",style:.Plain ,target:self,action:#selector(ViewController.display))
        self.navigationItem.rightBarButtonItem = rightButton

        
        // 建立輸入框
        myTextField = UITextField(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.95, height: 40))
        myTextField.placeholder = "請輸入文字"
        myTextField.clearButtonMode = .WhileEditing
        myTextField.returnKeyType = .Done
        myTextField.textColor = UIColor.whiteColor()
        myTextField.backgroundColor = UIColor.lightGrayColor()
        myTextField.delegate = self
        myTextField.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.2)
        self.view.addSubview(myTextField)

        
        // 建立更新與刪除按鈕
        var myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        myButton.setTitle("更新", forState: .Normal)
        myButton.backgroundColor = UIColor.blueColor()
        myButton.addTarget(self, action: #selector(ViewController.updateInfo), forControlEvents: .TouchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.3)
        self.view.addSubview(myButton)
        
        myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        myButton.setTitle("刪除", forState: .Normal)
        myButton.backgroundColor = UIColor.blueColor()
        myButton.addTarget(self, action: #selector(ViewController.removeInfo), forControlEvents: .TouchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.4)
        self.view.addSubview(myButton)
        
        
        // 如果已經存有值時 則填入輸入框
        if let info = myUserDefaults.objectForKey("info") as? String {
            myTextField.text = info
        }
    
    }
    
    func updateInfo() {
        print("update info")

        // 結束編輯 把鍵盤隱藏起來
        self.view.endEditing(true)
        
        myUserDefaults.setObject(myTextField.text, forKey: "info")
        myUserDefaults.synchronize()
    }
    
    func removeInfo() {
        print("remove info")

        myUserDefaults.removeObjectForKey("info")
        
        myTextField.text = ""
    }

    func display() {
        self.navigationController?.pushViewController(DisplayViewController(), animated: true)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // 更新資訊
        self.updateInfo()
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

