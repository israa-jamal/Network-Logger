//
//  CoreDataManager.swift
//  InstabugNetworkClient
//
//  Created by Esraa Gamal on 30/04/2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let modelName = "LoggerModel"
        
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: modelName, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
}
