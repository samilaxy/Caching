//
//  PersistenceController.swift
//  Caching
//
//  Created by Noye Samuel on 26/05/2023.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    private init() {
        UIImageTransformer.register()
        container = NSPersistentContainer(name: "ImageData")
        container.loadPersistentStores { description, error in
            if error != nil {
                fatalError("Failed to initialize Core Data stack: \(String(describing: error))")
            }
        }
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Failed to save Core Data context: \(error)")
            }
        }
    }
}
