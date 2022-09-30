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
    
    override func setUpWithError() throws {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_addCity() {
        objectToTest.homeCity = City(name: "Miami")
        
        XCTAssertEqual(objectToTest.homeCity?.name, "Miami")
        XCTAssertEqual(objectToTest.cities?.first?.name, "Miami")
    }
}
