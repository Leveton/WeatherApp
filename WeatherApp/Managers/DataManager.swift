//
//  DataManager.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation
import DataManager
import CoreData

open class DataManager: DataManagerProtocol {
    public var apiManager: APIManagerProtocol = APIManager.sharedInstance
    static let sharedInstance = DataManager()
}

open class RelationalDataManager: RelationalDataProtocol {
    public func fetchObject(forEntityName entityName: String, in context: NSManagedObjectContext, predicate: NSPredicate) -> Any? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        do {
            if let first = try context.fetch(fetchRequest).first {
                return first
            }
            return nil
        } catch let error as NSError {
            //TODO: Check the error message to determine which enum value to pass to Firebase Crashlytics
            print("fetchObject custom error::: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    lazy public var managedObjectContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let _ = error as NSError? {
                // Core data setup should not emit a fatal error because persistence and off-line data is just a nice to have
            }
        })
        print("Loaded computed persistentContainer:::")
        return container
    }()
    
    //Allows you to pass in a custom context
    //Allways wrap in a perform block and pass in the context doing the perform to keep things thread safe
    public func fetchAllObjects(forEntityName entityName: String, in context: NSManagedObjectContext, optionalPredicate: NSPredicate?) -> Result<[Any], RelationalDataManagerError> {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = optionalPredicate
        
        do {
            let objects = try context.fetch(fetchRequest)
            return .success(objects)
        } catch let error as NSError {
            //TODO: Check the error message to determine which enum value to pass to Firebase Crashlytics
            print("Fetch request custom error::: \(error.localizedDescription)")
            return .failure(.genericError)
        }
    }
    
    static let sharedInstance = RelationalDataManager()
}
