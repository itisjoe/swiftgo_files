//
//  ViewController.swift
//  ExSQLite
//
//  Created by joe feng on 2016/5/27.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var db :SQLiteConnect?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 資料庫檔案的路徑
        let sqlitePath = NSHomeDirectory() + "/Documents/sqlite3.db"
        
        // 印出儲存檔案的位置
        print(sqlitePath)
        
        // SQLite 資料庫
        db = SQLiteConnect(path: sqlitePath)
        
        if let mydb = db {
            
            // create table
            mydb.createTable("students", columnsInfo: [
                "id integer primary key autoincrement",
                "name text",
                "height double"])
        
            // insert
            mydb.insert("students", rowInfo: ["name":"'大強'","height":"178.2"])
        
            // select
            let statement = mydb.fetch("students", cond: "1 == 1")
            while sqlite3_step(statement) == SQLITE_ROW{
                let id = sqlite3_column_int(statement, 0)
                let name = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(statement, 1)))
                let height = sqlite3_column_double(statement, 2)
                print("\(id). \(name!) 身高： \(height)")
            }
            sqlite3_finalize(statement)
        
            // update
            mydb.update("students", cond: "id = 1", rowInfo: ["name":"'小強'","height":"176.8"])
        
            // delete
            mydb.delete("students", cond: "id = 5")

        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

