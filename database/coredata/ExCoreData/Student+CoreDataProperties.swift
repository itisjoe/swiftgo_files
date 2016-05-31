//
//  Student+CoreDataProperties.swift
//  ExCoreData
//
//  Created by joe feng on 2016/5/30.
//  Copyright © 2016年 hsin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Student {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var height: NSNumber?

}
