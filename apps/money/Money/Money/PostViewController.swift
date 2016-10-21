//
//  PostViewController.swift
//  Money
//
//  Created by joe feng on 2016/6/21.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextFieldDelegate {
    struct Record {
        var id :Int = 0
        var title :String?
        var amount :Double?
        var yearMonth :String?
        var createDate :String?
        var createTime :String?
    }
    
    let fullsize = UIScreen.main.bounds.size
    let myUserDefaults = UserDefaults.standard
    var db :SQLiteConnect?
    let myFormatter = DateFormatter()
    var myDatePicker :UIDatePicker!
    var record :Record!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recordId = myUserDefaults.object(forKey: "postID") as! Int
        let dbFileName = myUserDefaults.object(forKey: "dbFileName") as! String
        
        // 基本設定
        self.title = "新增"
        self.view.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        let height :CGFloat = 44.0
        let padding :CGFloat = 10.0
        
        db = SQLiteConnect(file: dbFileName)
        
        if let mydb = db {
            // 取得此筆資料內容
            myFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            record = Record(id: 0, title: nil, amount: nil, yearMonth: nil, createDate: nil, createTime: myFormatter.string(from: Date()))
            
            if recordId > 0 {
                self.title = "更新"
                let statement = mydb.fetch("records", cond: "id == \(recordId)", order: nil)
                if sqlite3_step(statement) == SQLITE_ROW{
                    record.id = Int(sqlite3_column_int(statement, 0))
                    record.title = String(cString: sqlite3_column_text(statement, 1))
                    
                    record.amount = sqlite3_column_double(statement, 2)
                    record.createTime = String(cString: sqlite3_column_text(statement, 5))

                }
                sqlite3_finalize(statement)
            }
            
            // 金額輸入框
            var myTextField = UITextField(frame: CGRect(x: 0.0, y: height * 0.3, width: fullsize.width, height: height))
            myTextField.keyboardType = .decimalPad
            myTextField.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
            myTextField.textAlignment = .right
            myTextField.textColor = UIColor.white
            myTextField.font = UIFont(name: "Helvetica Light", size: 24.0)
            myTextField.attributedPlaceholder = NSAttributedString(string: "金額", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            myTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: padding))
            myTextField.rightViewMode = .always
            myTextField.tag = 501
            myTextField.delegate = self
            if let str = record.amount {
                myTextField.text = String(format: "%g",str)
  }
            self.view.addSubview(myTextField)
            if recordId < 1 {
                myTextField.becomeFirstResponder()
            }
            
            // 金額顯示文字
            let dollarSignLabel = UILabel(frame: CGRect(x: padding, y: height * 0.3, width: 80, height: height))
            dollarSignLabel.font = UIFont(name: "Helvetica Light", size: 24.0)
            dollarSignLabel.textColor = UIColor.white
            dollarSignLabel.text = "$"
            self.view.addSubview(dollarSignLabel)
            
            // 事由輸入框
            myTextField = UITextField(frame: CGRect(x: 0.0, y: height * 1.6, width: fullsize.width, height: height))
            myTextField.keyboardType = .default
            myTextField.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
            myTextField.textAlignment = .right
            myTextField.textColor = UIColor.white
            myTextField.font = UIFont(name: "Helvetica Light", size: 24.0)
            myTextField.attributedPlaceholder = NSAttributedString(string: "事由", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            myTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: padding))
            myTextField.rightViewMode = .always
            myTextField.tag = 502
            myTextField.returnKeyType = .next
            myTextField.delegate = self
            if let str = record.title {
                myTextField.text = str 
            }
            self.view.addSubview(myTextField)
            
            // 日期輸入框
            myTextField = UITextField(frame: CGRect(x: 0.0, y: height * 2.9, width: fullsize.width, height: height))
            myTextField.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
            myTextField.textAlignment = .center
            myTextField.textColor = UIColor.white
            myTextField.font = UIFont(name: "Helvetica Light", size: 32.0)
            myTextField.text = record.createTime
            myTextField.tag = 503
            self.view.addSubview(myTextField)
            
            // UIDatePicker
            myDatePicker = UIDatePicker()
            myDatePicker.datePickerMode = .dateAndTime
            myDatePicker.locale = Locale(identifier: "zh_TW")
            myDatePicker.date = myFormatter.date(from: record.createTime!)!
            myTextField.inputView = myDatePicker
            
            // UIDatePicker 取消及完成按鈕
            let toolBar = UIToolbar()
            toolBar.barTintColor = UIColor.clear
            toolBar.sizeToFit()
            toolBar.barStyle = .default
            toolBar.tintColor = UIColor.white
            let cancelBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(PostViewController.cancelTouched(_:)))
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let doneBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(PostViewController.doneTouched(_:)))
            toolBar.items = [cancelBtn, space, doneBtn]
            myTextField.inputAccessoryView = toolBar
            
            // 儲存按鈕
            let saveBtn = UIButton(frame: CGRect(x: 0.0, y: height * 4.2, width: fullsize.width, height: height * 1.5))
            saveBtn.setTitle("儲存", for: .normal)
            saveBtn.setTitleColor(UIColor.black, for: .normal)
            saveBtn.backgroundColor = UIColor.init(red: 0.88, green: 0.83, blue: 0.73, alpha: 1)
            saveBtn.addTarget(self, action: #selector(PostViewController.saveBtnAction), for: .touchUpInside)
            self.view.addSubview(saveBtn)
            
            // 刪除按鈕
            if record.id != 0 {
                let deleteBtn = UIButton(frame: CGRect(x: 5.0, y: height * 5.8, width: 50, height: height))
                deleteBtn.setTitle("刪除", for: .normal)
                deleteBtn.setTitleColor(UIColor.red, for: .normal)
                deleteBtn.addTarget(self, action: #selector(PostViewController.deleteBtnAction), for: .touchUpInside)
                self.view.addSubview(deleteBtn)
            }

        }
        
        // 按空白處隱藏編輯狀態
        let tap = UITapGestureRecognizer(target: self,action:#selector(PostViewController.hideKeyboard(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    
// MARK: Button Actions
    
    // 刪除資訊
    func deleteBtnAction() {
        // 確認刪除框
        let alertController = UIAlertController(title: "刪除", message: "確認要刪除嗎？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "刪除", style: .default, handler: {
            (result) -> Void in
            if let mydb = self.db {
                _ = mydb.delete("records", cond: "id = \(self.record.id)")
            }
            
            _ = self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(okAction)

        self.present(alertController,animated: false,completion:nil)

    }

    // 儲存資訊
    func saveBtnAction() {
        // 取得金額
        var textField = self.view.viewWithTag(501) as! UITextField
        record.amount = Double(textField.text!) ?? 0

        // 取得事由
        textField = self.view.viewWithTag(502) as! UITextField
        record.title = textField.text ?? ""
        
        if record.title != "" {
            // 取得年月格式的時間
            record.yearMonth = (record.createTime! as NSString).substring(to: 7)
            
            // 取得年月日格式的時間
            record.createDate = (record.createTime! as NSString).substring(to: 10)
            
            if let mydb = db {
                let rowInfo = [
                    "title":"'\(record.title!)'",
                    "amount":"\(record.amount!)",
                    "yearMonth":"'\(record.yearMonth!)'",
                    "createDate":"'\(record.createDate!)'",
                    "createTime":"'\(record.createTime!)'"
                ]
                
                // 新增或更新 記錄
                if record.id > 0 {
                    _ = mydb.update("records", cond: "id = \(record.id)", rowInfo:rowInfo)
                } else {
                    _ = mydb.insert("records", rowInfo:rowInfo )
                }
                
                // 設定首頁要顯示這個記錄所屬的月份記錄列表
                myUserDefaults.set(record.yearMonth!, forKey: "displayYearMonth")
                myUserDefaults.synchronize()
                
                // 回到首頁
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }

    // 選取日期時 按下完成
    func doneTouched(_ sender:UIBarButtonItem) {
        let textField = self.view.viewWithTag(503) as! UITextField
        let date = myFormatter.string(from: myDatePicker.date)
        textField.text = date
        record.createTime = date

        hideKeyboard(nil)
    }

    // 選取日期時 按下取消
    func cancelTouched(_ sender:UIBarButtonItem) {
        hideKeyboard(nil)
    }

    
// MARK: UITextField Delegate Methods
    
    // 按下 return 鍵
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 事由欄位輸入時 點擊鍵盤[下一個]按鈕會跳往選取時間
        let title = self.view.viewWithTag(502) as! UITextField
        let date = self.view.viewWithTag(503) as! UITextField

        title.resignFirstResponder()
        date.becomeFirstResponder()

        return true
    }
    
    // 金額只能有一個小數點

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 501 {
            let oldString = textField.text as NSString? ?? ""
            let newString = oldString.replacingCharacters(in: range, with: string)
            var count = 0
            for c in newString.characters {
                if c == "." {
                    count = count + 1
                }
            }
            
            if count > 1 {
                return false
            }
        }
        
        return true
    }
    
    
// MARK: Functional Methods
    
    // 按空白處會隱藏編輯狀態
    func hideKeyboard(_ tapG:UITapGestureRecognizer?){
        self.view.endEditing(true)
    }
    
}
