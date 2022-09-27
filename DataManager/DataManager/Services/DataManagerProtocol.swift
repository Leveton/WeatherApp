//
//  DataManagerProtocol.swift
//  DataManager
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation

public protocol DataManagerProtocol {
    var apiManager: APIManagerProtocol { get }
}

// MARK: - Data interface
extension DataManagerProtocol {
    
    public func fetchCurrentSummary(withName name: String? = nil, withCoordinates coordinates: (lat: Double, long: Double)? = nil) async -> Result<Data?, APIManagerError> {
        return await apiManager.fetchCurrentSummary(withName: name, withCoordinates: coordinates)
    }
    
    //TODO: Change to Result Type
    public func fetchCityList(withCoordinateGroup group: [[Double]], completion: ((_ json: [String: Any]?, _ error: Error?) -> Void)?) {
        
        //Allow for caching
        
        apiManager.fetchCityList(withCoordinateGroup: group, completion: {json, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion?(nil, error)
                }
            } else if let json = json{
                DispatchQueue.main.async {
                    completion?(json, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion?(nil, nil)
                }
            }
        })
    }
}
