//
//  MockAPIManagerProtocol.swift
//  DataManagerTests
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation
@testable import DataManager

class MockAPIManager: APIManagerProtocol {
    var openWeatherAPIKey = "MOCK_API_KEY"
    
    var called_endpointURL = false
    var return_endpointURL: URL? = nil
    
    func endpointURL(for service: APIManagerService, queryParamters parameters: [String: String]?, seriesString: String?) -> URL? {
        called_endpointURL = true
        return return_endpointURL
    }
}
