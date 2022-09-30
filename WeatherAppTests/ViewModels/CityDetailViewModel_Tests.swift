//
//  CityDetailViewModel_Tests.swift
//  WeatherAppTests
//
//  Created by Michael Leveton on 9/30/22.
//

import Foundation
import XCTest
@testable import WeatherApp
@testable import DataManager

class CityDetailViewModel_Tests: XCTestCase {
    var objectToTest = CityDetailViewModel()
    var mockDataManager: MockDataManager?
    
    override func setUpWithError() throws {
        super.setUp()
        mockDataManager = MockDataManager()
        objectToTest.dataManager = MockDataManager()
    }
    
    override func tearDownWithError() throws {
        mockDataManager = nil
        super.tearDown()
    }
    
    func test_fetchForecastWithCoordinates() {
        
    }
    
    func test_fetchSummaryWithCoordinates() {
        
    }
    
    func test_fetchSummaryWithName() {
        
    }
}
