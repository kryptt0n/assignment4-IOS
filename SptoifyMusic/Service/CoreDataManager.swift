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
    
    
//    func addNewOwner(id: Int16, name: String, yrb: Int16) {
//        
//        var newOwner = Owner(context: persistentContainer.viewContext)
//        newOwner.id = id
//        newOwner.name = name
//        newOwner.yrb = yrb
//        
//        saveContext()
//        
//    }
//    
//    func addCarToOwner(cid: Int16, mod: String, year: Int16, owner: Owner) {
//        
//        var newCar = Car(context: persistentContainer.viewContext)
//        newCar.id = cid
//        newCar.model = mod
//        newCar.year = year
//        newCar.ownedBy = owner
//        
//        saveContext()
//        
//    }
//    
//    func getAllCarsForOneOwner(owner: Owner) -> [Car] {
//        var cars = [Car]()
//        
//        var fetchRequest = Owner.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %d", owner.id)
//        
//        do {
//            var fetchOwner = try persistentContainer.viewContext.fetch(fetchRequest)
//            cars = fetchOwner[0].owns!.allObjects as! [Car]
//        } catch {
//            print(error)
//        }
//        
//        return cars
//    }
//    
//    func getAllCars()->[Car] {
//        var cars = [Car]()
//        
//        var fetchRequest = Car.fetchRequest()
//        
//        do {
//            cars = try persistentContainer.viewContext.fetch(fetchRequest)
//        } catch {
//            print(error)
//        }
//        
//        return cars
//    }
//    
//    func getAllOwners()->[Owner] {
//        
//        var listOfOwners = [Owner]()
//        
//        var fetchRequest = Owner.fetchRequest()
////        fetchRequest.predicate = NSPredicate(format: "name BEGINS WITH %@")
////        fetchRequest.predicate = NSPredicate(format: "yrb == %d", 1990)
////        var sorting = NSSortDescriptor(key: "name", ascending: true)
////        fetchRequest.sortDescriptors = [sorting]
//        do {
//            listOfOwners = try persistentContainer.viewContext.fetch(fetchRequest)
//        } catch {
//            print(error)
//        }
//        
//        return listOfOwners
//        
//    }
//    
//    func deleteAllCars() {
//        
//        var cars = getAllCars()
//        
//        for car in cars {
//            persistentContainer.viewContext.delete(car)
//        }
//        
//    }
//    
//    func deleteOneCarForOwner(owner: Owner, car: Car) {
//        var cars = [Car]()
//        
//        var fetchRequest = Owner.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %d", owner.id)
//        
//        do {
//            var fetchOwner = try persistentContainer.viewContext.fetch(fetchRequest)
//            cars = fetchOwner[0].owns!.allObjects as! [Car]
//            cars.removeAll { carInArr in
//                carInArr.id == car.id
//            }
//        } catch {
//            print(error)
//        }
//    }

    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SptoifyMusic")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

