//
//  MockDataManagerProtocol.swift
//  DataManagerTests
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation
@testable import DataManager

class MockDataManager: DataManagerProtocol {
    var apiManager: APIManagerProtocol = MockAPIManager()
    
}
