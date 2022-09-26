//
//  APIManagerProtocol.swift
//  DataManager
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation

public protocol APIManagerProtocol {
}

public enum APIManagerService {
    case currentSummary
}

// MARK: - APIManager Protocol Methods
extension APIManagerProtocol {
    
    //TODO: Change to Result Type
    public func fetchCurrentSummary(withCoordinates coordinates: (lat: Double, long: Double), completion: ((_ json: [String: Any]?, _ error: Error?) -> Void)?) {
        completion?(nil, nil)
    }
    
    //TODO: Change to Result Type
    public func fetchCityList(withCoordinateGroup group: [[Double]], completion: ((_ json: [String: Any]?, _ error: Error?) -> Void)?) {
        completion?(nil, nil)
    }
}
