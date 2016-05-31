//
//  ViewController.swift
//  ExCoreData
//
//  Created by joe feng on 2016/5/30.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 用來操作 Core Data 的常數
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myEntityName = "Student"
        let coreDataConnect = CoreDataConnect(moc: self.moc)

        // auto increment
        let myUserDefaults = NSUserDefaults.standardUserDefaults()
        var seq = 1
        if let idSeq = myUserDefaults.objectForKey("idSeq") as? Int {
            seq = idSeq + 1
        }
        
        // insert
        let insertResult = coreDataConnect.insert(
            myEntityName, attributeInfo: [
                "id" : "\(seq)",
                "name" : "小強",
                "height" : "176.1"
            ])
        if insertResult {
            print("新增資料成功")
            
            myUserDefaults.setObject(seq, forKey: "idSeq")
            myUserDefaults.synchronize()
        }
        
        // select
        let selectResult = coreDataConnect.fetch(myEntityName, predicate: nil, sort: ["id":true])
        if let results = selectResult {
            for result in results {
                print("\(result.id). \(result.name!) 身高： \(result.height)")
            }
        }
        
        // update
        let updateName = "二強"
        var predicate = "name = '\(updateName)'"
        let updateResult = coreDataConnect.update(myEntityName, predicate: predicate, attributeInfo: ["height":"162.2"])
        if updateResult {
            print("更新資料成功")
        }
        
        // delete
        let deleteID = 2
        predicate = "id = \(deleteID)"
        let deleteResult = coreDataConnect.delete(myEntityName, predicate: predicate)
        if deleteResult {
            print("刪除資料成功")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

