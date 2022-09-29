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
    
    //Find current weather by name or lat-long
    public func fetchCurrentSummary(withName name: String? = nil, withCoordinates coordinates: (lat: Double, long: Double)? = nil) async -> Result<Data?, APIManagerError> {
        //Allow for caching with NSCache or Core Data
        return await apiManager.fetchCurrentSummary(withName: name, withCoordinates: coordinates)
    }
    
    //Find 5 day / 3 hour forecast data
    public func fetchFiveDayForcast(withCoordinates coordinates: (lat: Double, long: Double)) async -> Result<Data?, APIManagerError> {
        return await apiManager.fetchFiveDayForcast(withCoordinates: coordinates)
    }
}
