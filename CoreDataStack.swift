//
//  CoreDataStack.swift
//  Recky
//
//  Created by Samina Abdullah on 7/25/18.
//  Copyright © 2018 Samina Abdullah. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var container: NSPersistentContainer{
        let container = NSPersistentContainer(name: "Recommendation")
        container.loadPersistentStores { (description, error) in
            guard error == nil else{
                print("Error: \(error!)")
                return
            }
        }
        return container
    }
    
    var managedContext: NSManagedObjectContext{
        return container.viewContext
    }
}
