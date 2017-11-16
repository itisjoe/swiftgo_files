//
//  ViewController.swift
//  ExUserDefaults
//
//  Created by joe feng on 2016/10/17.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    // 取得螢幕的尺寸
    let fullSize = UIScreen.main.bounds.size
    
    var myTextField: UITextField!
    var myUserDefaults :UserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 設置底色
        self.view.backgroundColor = UIColor.white
        
        // 取得儲存的預設資料
        myUserDefaults = UserDefaults.standard
        
        // 設置導覽列內容
        self.title = "首頁"
        self.navigationController?.navigationBar.isTranslucent = false
        let rightButton = UIBarButtonItem(title:"顯示",style:.plain ,target:self,action:#selector(ViewController.display))
        self.navigationItem.rightBarButtonItem = rightButton
        
        
        // 建立輸入框
        myTextField = UITextField(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.95, height: 40))
        myTextField.placeholder = "請輸入文字"
        myTextField.clearButtonMode = .whileEditing
        myTextField.returnKeyType = .done
        myTextField.textColor = UIColor.white
        myTextField.backgroundColor = UIColor.lightGray
        myTextField.delegate = self
        myTextField.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.2)
        self.view.addSubview(myTextField)
        
        
        // 建立更新與刪除按鈕
        var myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        myButton.setTitle("更新", for: .normal)
        myButton.backgroundColor = UIColor.blue
        myButton.addTarget(self, action: #selector(ViewController.updateInfo), for: .touchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.3)
        self.view.addSubview(myButton)
        
        myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        myButton.setTitle("刪除", for: .normal)
        myButton.backgroundColor = UIColor.blue
        myButton.addTarget(self, action: #selector(ViewController.removeInfo), for: .touchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.4)
        self.view.addSubview(myButton)
        
        
        // 如果已經存有值時 則填入輸入框
        if let info = myUserDefaults.object(forKey: "info") as? String {
            myTextField.text = info
        }

    }

    @objc func updateInfo() {
        print("update info")
        
        // 結束編輯 把鍵盤隱藏起來
        self.view.endEditing(true)
        
        myUserDefaults.set(myTextField.text, forKey: "info")
        myUserDefaults.synchronize()
    }
    
    @objc func removeInfo() {
        print("remove info")
        
        myUserDefaults.removeObject(forKey: "info")
        
        myTextField.text = ""
    }
    
    @objc func display() {
        self.navigationController?.pushViewController(DisplayViewController(), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 更新資訊
        self.updateInfo()
        
        return true
    }

}

