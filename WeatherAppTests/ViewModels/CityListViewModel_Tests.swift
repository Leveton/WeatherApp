//
//  CityListViewModel_tests.swift
//  WeatherAppTests
//
//  Created by Michael Leveton on 9/30/22.
//

import Foundation
import XCTest
@testable import WeatherApp
@testable import DataManager

class CityListViewModel_Tests: XCTestCase {
    var objectToTest = CityListViewModel()
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
    
    func test_addCity() {
        objectToTest.homeCity = City(name: "Miami")
        
        XCTAssertEqual(objectToTest.homeCity?.name, "Miami")
        XCTAssertEqual(objectToTest.cities?.first?.name, "Miami")
    }
    
    func test_addCityAsync() async {
        let romeCoords = (lat: 41.9102415, long: 12.3959128)
        
        let cityArray = await objectToTest.addCityAsync(forCoordinates: romeCoords)
        guard let name = cityArray?.first?.name  else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(name, "Rome")
    }
    
    func test_fetchCitiesAsync() async {
        var city = City(name: "Rome")
        city.lat = 41.9102415
        city.lon = 12.3959128
        
        objectToTest.cities = [city]
        let cityArray = await objectToTest.fetchCitiesAsync()
        guard let name = cityArray?.first?.name  else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(name, "Rome")
    }
}
