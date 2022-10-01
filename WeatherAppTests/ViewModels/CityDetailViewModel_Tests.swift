//
//  CityDetailViewModel_Tests.swift
//  WeatherAppTests
//
//  Created by Michael Leveton on 9/30/22.
//

import UIKit
import XCTest
@testable import WeatherApp
@testable import DataManager

class CityDetailViewModel_Tests: XCTestCase {
    var objectToTest = CityDetailViewModel()
    var mockDataManager: DataManagerProtocol = MockDataManager()
    
    override func setUpWithError() throws {
        super.setUp()
        //mockDataManager = MockDataManager()
        objectToTest.dataManager = mockDataManager
    }
    
    override func tearDownWithError() throws {
        //mockDataManager = nil
        super.tearDown()
    }
    
    //TODO: this needs to be implemented first
    func test_fetchForecastWithCoordinates() {
        
    }
    
    func test_fetchSummaryWithCoordinates() async {
        let city = City(name: "Rome")

        objectToTest.cities = [city]
        await objectToTest.fetchSummaryWithCoordinates((lat: 41.9102415, long: 12.3959128))
        DispatchQueue.main.async {
            guard let name = self.objectToTest.city?.name  else {
                XCTFail()
                return
            }

            XCTAssertEqual(name, "Rome")
        }
    }
    
    func test_fetchSummaryWithName() async {
        let city = City(name: "Rome")

        objectToTest.cities = [city]
        await objectToTest.fetchSummaryWithName("Rome")
        DispatchQueue.main.async {
            guard let name = self.objectToTest.city?.name  else {
                XCTFail()
                return
            }

            XCTAssertEqual(name, "Rome")
        }
    }
}
