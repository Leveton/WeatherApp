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
    
    public func fetchCurrentSummary(withCoordinates coordinates: String, completion: ((_ json: [String: Any]?, _ error: Error?) -> Void)?) {
        completion?(nil, nil)
    }
}
