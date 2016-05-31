//
//  CoreDataConnect.swift
//  ExCoreData
//
//  Created by joe feng on 2016/5/31.
//  Copyright © 2016年 hsin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataConnect {
    var moc :NSManagedObjectContext!
    
    init(moc:NSManagedObjectContext) {
        self.moc = moc
    }
    
    // insert
    func insert(myEntityName:String, attributeInfo:[String:String]) -> Bool {
        let student = NSEntityDescription.insertNewObjectForEntityForName(myEntityName, inManagedObjectContext: self.moc) as! Student
        
        for (key,value) in attributeInfo {
            let t = student.entity.attributesByName[key]?.attributeType

            if t == .Integer16AttributeType || t == .Integer32AttributeType || t == .Integer64AttributeType {
                student.setValue(Int(value), forKey: key)
            } else if t == .DoubleAttributeType || t == .FloatAttributeType {
                student.setValue(Double(value), forKey: key)
            } else {
                student.setValue(value, forKey: key)
            }
        }
        
        do {
            try moc.save()

            return true
        } catch {
            fatalError("\(error)")
        }
        
        return false
    }

    // select
    func fetch (myEntityName:String, predicate:String?, sort:[String:Bool]?) -> [Student]? {
        let request = NSFetchRequest(entityName: myEntityName)
       
        // predicate
        if let myPredicate = predicate {
            request.predicate = NSPredicate(format: myPredicate)
        }
        
        // sort
        if let mySort = sort {
            var sortArr :[NSSortDescriptor] = []
            for (k, asc) in mySort {
                sortArr.append(NSSortDescriptor(key: k, ascending: asc))
            }
            
            request.sortDescriptors = sortArr
        }
        
        do {
            let results = try moc.executeFetchRequest(request) as! [Student]
            
            return results
        } catch {
            fatalError("\(error)")
        }
        
        return nil
    }

    // update
    func update(myEntityName:String, predicate:String?, attributeInfo:[String:String]) -> Bool {
        if let results = self.fetch(myEntityName, predicate: predicate, sort: nil) {
            for result in results {
                for (key,value) in attributeInfo {
                    let t = result.entity.attributesByName[key]?.attributeType

                    if t == .Integer16AttributeType || t == .Integer32AttributeType || t == .Integer64AttributeType {
                        result.setValue(Int(value), forKey: key)
                    } else if t == .DoubleAttributeType || t == .FloatAttributeType {
                        result.setValue(Double(value), forKey: key)
                    } else {
                        result.setValue(value, forKey: key)
                    }
                }
            }

            do {
                try self.moc.save()

                return true
            } catch {
                fatalError("\(error)")
            }
        }
    
        return false
    }
    
    // delete
    func delete(myEntityName:String, predicate:String?) -> Bool {
        if let results = self.fetch(myEntityName, predicate: predicate, sort: nil) {
            for result in results {
                self.moc.deleteObject(result)
            }
            
            do {
                try self.moc.save()
                
                return true
            } catch {
                fatalError("\(error)")
            }
        }
        
        return false
    }
    
}
