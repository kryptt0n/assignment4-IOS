//
//  CoreDataManager.swift
//  CarOwnerApp
//
//  Created by Виталий Сухинин on 29.11.2024.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    func addToken(value: String, tokenType: String) {
        var token = Token(context: persistentContainer.viewContext)
        token.value = value
        token.tokenType = tokenType
        
        saveContext()
    }
    
    func getToken() -> Token? {
        var fetchRequest = Token.fetchRequest()
        
        do {
            var fetchToken = try persistentContainer.viewContext.fetch(fetchRequest)
            return fetchToken.last!
        } catch {
            print(error)
        }
        
        return nil
    }
    

    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "SptoifyMusic")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

