//
//  RelationalDataProtocol.swift
//  DataManager
//
//  Created by Michael Leveton on 9/29/22.
//

import Foundation
import CoreData

public enum RelationalDataManagerError: Error {
    case noParentDirectory, unableToCreate, unableToWrite, invalidPermissions, noSpaceInDevice, migrationImpossible, genericError
}

public protocol RelationalDataProtocol {
    var managedObjectContext: NSManagedObjectContext { get }
    func fetchAllObjects(forEntityName entityName: String, in context: NSManagedObjectContext, optionalPredicate: NSPredicate?) -> Result<[Any], RelationalDataManagerError>
    func fetchObject(forEntityName entityName: String, in context: NSManagedObjectContext, predicate: NSPredicate) -> Any?
    
    func walkArray(withServerArray serverArrayKeys: [String], againstCoreDataArray coreDataArrayKeys: [String], update updateBlock: @escaping (String, String) -> Void, add addBlock: @escaping (String) -> Void, delete deleteBlock: @escaping (String) -> Void, withCompletion completion: @escaping () -> Void)
}

//For types that need to talk to the API as well as sync to Core Data
public protocol DataProvider: DataManagerProtocol, RelationalDataProtocol {
    
}
