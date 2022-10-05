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
    
    public func walkArray(withServerArray serverArrayKeys: [String], againstCoreDataArray coreDataArrayKeys: [String], update updateBlock: @escaping (String, String) -> Void, add addBlock: @escaping (String) -> Void, delete deleteBlock: @escaping (String) -> Void, withCompletion completion: @escaping () -> Void) {
        var serverArrayKeys = serverArrayKeys.sorted()
        var coreDataArrayKeys = coreDataArrayKeys.sorted()
        
//        //Scan up to Core Data objects that aren't null
//        var firstNotNullIdIndex: Int = 0
//        while firstNotNullIdIndex < coreDataArrayKeys.count && coreDataArrayKeys[firstNotNullIdIndex] == nil {
//            firstNotNullIdIndex += 1
//        }
//
//        //Create a new array of just core data objects with null ID's
//        let nullObjects: [String]? = {
//            if firstNotNullIdIndex > 0 {
//                return Array(coreDataArrayKeys[0..<firstNotNullIdIndex])
//            } else {
//                return nil
//            }
//        }()
        
        //Update the core data arrays to have just existing objects
//        if firstNotNullIdIndex > 0 {
//            let notNullCount = coreDataArrayKeys.count - (nullObjects?.count ?? 0)
//            if notNullCount > 0 {
//                coreDataArrayKeys = Array(coreDataArrayKeys[firstNotNullIdIndex..<coreDataArrayKeys.count])
//            } else {
//                coreDataArrayKeys = []
//            }
//        }
        
        // Walk the two arrays
        var serverObjectIDsToAdd = [String]()
        var coreDataIndexesToRemove = [Int]()
        
        var serverArrayIndex: Int = 0
        var coreDataArrayIndex: Int = 0
        
        while serverArrayIndex < serverArrayKeys.count || coreDataArrayIndex < coreDataArrayKeys.count {

            var result: ComparisonResult = .orderedSame

            if serverArrayIndex == serverArrayKeys.count {
                //The left operand is greator than the right operand
                result = .orderedDescending
            } else if coreDataArrayIndex == coreDataArrayKeys.count {
                //The right operand is greator than the left operand
                result = .orderedAscending
            } else {

                let serverObjectValue = serverArrayKeys[serverArrayIndex]
                let serverObjectValueString = "\(serverObjectValue)"
                let coreDataObjectValue = coreDataArrayKeys[coreDataArrayIndex]
                let coreDataObjectValueString = "\(coreDataObjectValue)"

                result = serverObjectValueString.compare(coreDataObjectValueString)

            }

            switch result {
            case .orderedSame:
                //Key matches for both arrays so update with the object from the server
                updateBlock(serverArrayKeys[serverArrayIndex], coreDataArrayKeys[coreDataArrayIndex])
                serverArrayIndex += 1
                coreDataArrayIndex += 1
            case .orderedAscending:
                //Found new server object to add
                serverObjectIDsToAdd.append(serverArrayKeys[serverArrayIndex])
                serverArrayIndex += 1
            case .orderedDescending:
                //core data object present that's missing from the server
                coreDataIndexesToRemove.append(coreDataArrayIndex)
                coreDataArrayIndex += 1
            }

        }
        
        coreDataIndexesToRemove.forEach { index in
            deleteBlock(coreDataArrayKeys[index])
        }

//        nullObjects?.forEach{
//            deleteBlock($0)
//        }

        serverObjectIDsToAdd.forEach {
            addBlock($0)
        }
        
        completion()
    }
    
    static let sharedInstance = RelationalDataManager()
}
