//
//  SQLiteConnect.swift
//  ExSQLite
//
//  Created by joe feng on 2016/5/27.
//  Copyright © 2016年 hsin. All rights reserved.
//

import Foundation

class SQLiteConnect {
    
    var db :COpaquePointer = nil
    let sqlitePath :String
    
    init?(path :String) {
        sqlitePath = path
        db = self.openDatabase(sqlitePath)
        
        if db == nil {
            return nil
        }
    }
    
    // 連結資料庫 connect database
    func openDatabase(path :String) -> COpaquePointer {
        var connectdb: COpaquePointer = nil
        if sqlite3_open(path, &connectdb) == SQLITE_OK {
            print("Successfully opened database \(path)")
            return connectdb
        } else {
            print("Unable to open database.")
            return nil
        }
    }
    
    // 建立資料表 create table
    func createTable(tableName :String, columnsInfo :[String]) -> Bool {
        let sql = "create table if not exists \(tableName) "
                + "(\(columnsInfo.joinWithSeparator(",")))" as NSString

        if sqlite3_exec(self.db, sql.UTF8String, nil, nil, nil) == SQLITE_OK{
            return true
        }
        
        return false
    }
    
    // 新增資料
    func insert(tableName :String, rowInfo :[String:String]) -> Bool {
        var statement :COpaquePointer = nil
        let sql = "insert into \(tableName) "
                + "(\(rowInfo.keys.joinWithSeparator(","))) "
                + "values (\(rowInfo.values.joinWithSeparator(",")))" as NSString
        
        if sqlite3_prepare_v2(self.db, sql.UTF8String, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                return true
            }
            sqlite3_finalize(statement)
        }
        
        return false
    }
    
    // 讀取資料
    func fetch(tableName :String, cond :String?) -> COpaquePointer {
        var statement :COpaquePointer = nil
        var sql = "select * from \(tableName)"
        if let condition = cond {
            sql += " where \(condition)"
        }

        sqlite3_prepare_v2(self.db, sql, -1, &statement, nil)

        return statement
    }
    
    // 更新資料
    func update(tableName :String, cond :String?, rowInfo :[String:String]) -> Bool {
        var statement :COpaquePointer = nil
        var sql = "update \(tableName) set "
        
        // row info
        var info :[String] = []
        for (k, v) in rowInfo {
            info.append("\(k) = \(v)")
        }
        sql += info.joinWithSeparator(",")
        
        // condition
        if let condition = cond {
            sql += " where \(condition)"
        }

        if sqlite3_prepare_v2(self.db, (sql as NSString).UTF8String, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                return true
            }
            sqlite3_finalize(statement)
        }
        
        return false
    
    }
    
    // 刪除資料
    func delete(tableName :String, cond :String?) -> Bool {
        var statement :COpaquePointer = nil
        var sql = "delete from \(tableName)"

        // condition
        if let condition = cond {
            sql += " where \(condition)"
        }
        
        if sqlite3_prepare_v2(self.db, (sql as NSString).UTF8String, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                return true
            }
            sqlite3_finalize(statement)
        }
        
        return false
    }
    
}
