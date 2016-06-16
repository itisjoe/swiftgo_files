//
//  Record+CoreDataProperties.swift
//  ToDo
//
//  Created by joe feng on 2016/6/16.
//  Copyright © 2016年 hsin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Record {

    @NSManaged var id: NSNumber?
    @NSManaged var content: String?
    @NSManaged var seq: NSNumber?
    @NSManaged var done: NSNumber?

}
