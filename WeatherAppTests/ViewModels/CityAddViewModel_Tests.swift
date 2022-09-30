//
//  CityAddViewModel_Tests.swift
//  WeatherAppTests
//
//  Created by Michael Leveton on 9/30/22.
//

import Foundation
import XCTest
@testable import WeatherApp
@testable import DataManager

class CityAddViewModel_Tests: XCTestCase {
    var objectToTest = CityAddViewModel()
    var mockGoogleManager: MockGoogleManager?
    
    override func setUpWithError() throws {
        super.setUp()
        mockGoogleManager = MockGoogleManager()
        objectToTest.googlePlacesManager = mockGoogleManager!
    }
    
    override func tearDownWithError() throws {
        mockGoogleManager = nil
        super.tearDown()
    }
    
    func test_getCoords() {
        guard let mockGoogleManager = mockGoogleManager else {
            XCTFail()
            return
        }
        
        XCTAssertFalse(mockGoogleManager.called_completion)
        objectToTest.getCoords(forCity: City(name: "Miami"))
        XCTAssertFalse(mockGoogleManager.called_completion)
        objectToTest.getCoords(forCity: City(name: "Rome"))
        XCTAssertTrue(mockGoogleManager.called_completion)
    }
    
    func test_findPlaces() {
        guard let mockGoogleManager = mockGoogleManager else {
            XCTFail()
            return
        }
        XCTAssertFalse(mockGoogleManager.called_completion)
        objectToTest.findPlaces(withQuery: "Miami")
        XCTAssertTrue(mockGoogleManager.called_completion)
    }
}
