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
    
    let fullsize = UIScreen.mainScreen().bounds.size
    let myUserDefaults = NSUserDefaults.standardUserDefaults()
    var db :SQLiteConnect?
    let myFormatter = NSDateFormatter()
    var myDatePicker :UIDatePicker!
    var record :Record!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recordId = myUserDefaults.objectForKey("postID") as! Int
        let dbFileName = myUserDefaults.objectForKey("dbFileName") as! String
        
        // 基本設定
        self.title = "新增"
        self.view.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        self.navigationController?.navigationBar.translucent = false
        let height :CGFloat = 44.0
        let padding :CGFloat = 10.0
        
        db = SQLiteConnect(file: dbFileName)
        
        if let mydb = db {
            // 取得此筆資料內容
            myFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            record = Record(id: 0, title: nil, amount: nil, yearMonth: nil, createDate: nil, createTime: myFormatter.stringFromDate(NSDate()))
            
            if recordId > 0 {
                self.title = "更新"
                let statement = mydb.fetch("records", cond: "id == \(recordId)", order: nil)
                if sqlite3_step(statement) == SQLITE_ROW{
                    record.id = Int(sqlite3_column_int(statement, 0))
                    record.title = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(statement, 1))) ?? ""
                    record.amount = sqlite3_column_double(statement, 2)
                    record.createTime = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(statement, 5))) ?? record.createTime

                }
                sqlite3_finalize(statement)
            }
            
            // 金額輸入框
            var myTextField = UITextField(frame: CGRect(x: 0.0, y: height * 0.5, width: fullsize.width, height: height))
            myTextField.keyboardType = .DecimalPad
            myTextField.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
            myTextField.textAlignment = .Right
            myTextField.textColor = UIColor.whiteColor()
            myTextField.font = UIFont(name: "Helvetica Light", size: 24.0)
            myTextField.attributedPlaceholder = NSAttributedString(string: "金額", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            myTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: padding))
            myTextField.rightViewMode = .Always
            myTextField.tag = 501
            myTextField.delegate = self
            if let str = record.amount {
                myTextField.text = String(format: "%g",str) ?? ""
            }
            self.view.addSubview(myTextField)
            if recordId < 1 {
                myTextField.becomeFirstResponder()
            }
            
            // 金額顯示文字
            let dollarSignLabel = UILabel(frame: CGRect(x: padding, y: height * 0.5, width: 80, height: height))
            dollarSignLabel.font = UIFont(name: "Helvetica Light", size: 24.0)
            dollarSignLabel.textColor = UIColor.whiteColor()
            dollarSignLabel.text = "$"
            self.view.addSubview(dollarSignLabel)
            
            // 事由輸入框
            myTextField = UITextField(frame: CGRect(x: 0.0, y: height * 2, width: fullsize.width, height: height))
            myTextField.keyboardType = .Default
            myTextField.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
            myTextField.textAlignment = .Right
            myTextField.textColor = UIColor.whiteColor()
            myTextField.font = UIFont(name: "Helvetica Light", size: 24.0)
            myTextField.attributedPlaceholder = NSAttributedString(string: "事由", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            myTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: padding))
            myTextField.rightViewMode = .Always
            myTextField.tag = 502
            myTextField.returnKeyType = .Next
            myTextField.delegate = self
            if let str = record.title {
                myTextField.text = str ?? ""
            }
            self.view.addSubview(myTextField)
            
            // 日期輸入框
            myTextField = UITextField(frame: CGRect(x: 0.0, y: height * 3.5, width: fullsize.width, height: height))
            myTextField.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
            myTextField.textAlignment = .Center
            myTextField.textColor = UIColor.whiteColor()
            myTextField.font = UIFont(name: "Helvetica Light", size: 32.0)
            myTextField.text = record.createTime
            myTextField.tag = 503
            self.view.addSubview(myTextField)
            
            // UIDatePicker
            myDatePicker = UIDatePicker()
            myDatePicker.datePickerMode = .DateAndTime
            myDatePicker.locale = NSLocale(localeIdentifier: "zh_TW")
            myDatePicker.date = myFormatter.dateFromString(record.createTime!)!
            myTextField.inputView = myDatePicker
            
            // UIDatePicker 取消及完成按鈕
            let toolBar = UIToolbar()
            toolBar.barTintColor = UIColor.clearColor()
            toolBar.sizeToFit()
            toolBar.barStyle = .Default
            toolBar.tintColor = UIColor.whiteColor()
            let cancelBtn = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(PostViewController.cancelTouched(_:)))
            let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
            let doneBtn = UIBarButtonItem(title: "完成", style: .Plain, target: self, action: #selector(PostViewController.doneTouched(_:)))
            toolBar.items = [cancelBtn, space, doneBtn]
            myTextField.inputAccessoryView = toolBar
            
            // 儲存按鈕
            let saveBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: fullsize.width, height: height * 1.5))
            saveBtn.setTitle("儲存", forState: .Normal)
            saveBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            saveBtn.backgroundColor = UIColor.init(red: 0.88, green: 0.83, blue: 0.73, alpha: 1)
            saveBtn.center = CGPoint(x: fullsize.width * 0.5, y: fullsize.height - 64 - height)
            saveBtn.addTarget(self, action: #selector(PostViewController.saveBtnAction), forControlEvents: .TouchUpInside)
            self.view.addSubview(saveBtn)
            
            // 刪除按鈕
            if record.id != 0 {
                let deleteBtn = UIButton(frame: CGRect(x: 5.0, y: fullsize.height - 64 - height * 2.8, width: 50, height: height))
                deleteBtn.setTitle("刪除", forState: .Normal)
                deleteBtn.setTitleColor(UIColor.redColor(), forState: .Normal)
                deleteBtn.addTarget(self, action: #selector(PostViewController.deleteBtnAction), forControlEvents: .TouchUpInside)
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
        let alertController = UIAlertController(title: "刪除", message: "確認要刪除嗎？", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "刪除", style: .Default, handler: {
            (result) -> Void in
            if let mydb = self.db {
                mydb.delete("records", cond: "id = \(self.record.id)")
            }
            
            self.navigationController?.popViewControllerAnimated(true)
        })
        alertController.addAction(okAction)

        self.presentViewController(alertController,animated: false,completion:nil)

    }

    // 儲存資訊
    func saveBtnAction() {
        var textField = self.view.viewWithTag(501) as! UITextField
        record.amount = Double(textField.text!) ?? 0

        textField = self.view.viewWithTag(502) as! UITextField
        record.title = textField.text ?? ""
        
        if record.title != "" {
            record.yearMonth = (record.createTime! as NSString).substringToIndex(7)
            record.createDate = (record.createTime! as NSString).substringToIndex(10)
            
            if let mydb = db {
                let rowInfo = [
                    "title":"'\(record.title!)'",
                    "amount":"\(record.amount!)",
                    "yearMonth":"'\(record.yearMonth!)'",
                    "createDate":"'\(record.createDate!)'",
                    "createTime":"'\(record.createTime!)'"
                ]
                
                if record.id > 0 {
                    mydb.update("records", cond: "id = \(record.id)", rowInfo:rowInfo)
                } else {
                    mydb.insert("records", rowInfo:rowInfo )
                }
                
                myUserDefaults.setObject(record.yearMonth!, forKey: "displayYearMonth")
                myUserDefaults.synchronize()
                
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }

    // 選取日期時 按下完成
    func doneTouched(sender:UIBarButtonItem) {
        let textField = self.view.viewWithTag(503) as! UITextField
        let date = myFormatter.stringFromDate(myDatePicker.date)
        textField.text = date
        record.createTime = date

        hideKeyboard(nil)
    }

    // 選取日期時 按下取消
    func cancelTouched(sender:UIBarButtonItem) {
        hideKeyboard(nil)
    }

    
// MARK: UITextField Delegate Methods
    
    // 按下 return 鍵
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let title = self.view.viewWithTag(502) as! UITextField
        let date = self.view.viewWithTag(503) as! UITextField
        
        title.resignFirstResponder()
        date.becomeFirstResponder()
        
        return true
    }
    
    // 金額只能有一個小數點
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 501 {
            let oldString = textField.text ?? "" as NSString
            let newString = oldString.stringByReplacingCharactersInRange(range, withString: string)
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
    func hideKeyboard(tapG:UITapGestureRecognizer?){
        self.view.endEditing(true)
    }
    
}
