//
//  ViewController.swift
//  ExCoreData
//
//  Created by joe feng on 2016/5/30.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    // 用來操作 Core Data 的常數
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myEntityName = "Student"

        let myUserDefaults = NSUserDefaults.standardUserDefaults()
        var seq = 1
        if let idSeq = myUserDefaults.objectForKey("idSeq") as? Int {
            seq = idSeq + 1
        }
        
        // insert
        let student = NSEntityDescription.insertNewObjectForEntityForName(myEntityName, inManagedObjectContext: self.moc) as! Student
        student.id = seq
        student.name = "小強"
        student.height = 173.2
        do {
            try self.moc.save()
            
            myUserDefaults.setObject(seq, forKey: "idSeq")
            myUserDefaults.synchronize()
        } catch {
            fatalError("\(error)")
        }
        
        // select
        let request = NSFetchRequest(entityName: myEntityName)
        
        // 依 id 由小到大排序
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        do {
            let results = try moc.executeFetchRequest(request) as! [Student]
            
            for result in results {
                print("\(result.id). \(result.name!) 身高： \(result.height)")
            }
        } catch {
            fatalError("\(error)")
        }
        
        // update
        request.predicate = nil
        let updateID = "小強"
        request.predicate = NSPredicate(format: "name = '\(updateID)'")

        do {
            let results = try moc.executeFetchRequest(request) as! [Student]
            
            if results.count > 0 {
                results[0].height = 155
                try self.moc.save()
            }
        } catch {
            fatalError("\(error)")
        }
        
        // delete
        request.predicate = nil
        let deleteID = 3
        request.predicate = NSPredicate(format: "id = \(deleteID)")
        
        do {
            let results = try moc.executeFetchRequest(request) as! [Student]
            
            for result in results {
                print("\(result.id). \(result.name!) 身高： \(result.height)")
                self.moc.deleteObject(result)
            }
            try self.moc.save()
            
        } catch {
            fatalError("\(error)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

