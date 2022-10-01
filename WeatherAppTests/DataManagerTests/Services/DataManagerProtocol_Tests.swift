//
//  DataManagerProtocol_Tests.swift
//  DataManagerTests
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation
import XCTest
@testable import DataManager
@testable import WeatherApp

class DataManagerProtocol_Tests: XCTestCase {
    var mockDataManager: DataManagerProtocol?
    
    override func setUpWithError() throws {
        super.setUp()
        mockDataManager = MockDataManager()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        mockDataManager = nil
        super.tearDown()
    }
    
    func test_fetchCurrentSummary() async {
        guard let mockDataManager = mockDataManager as? MockDataManager else {
            XCTFail()
            return
        }
        
        XCTAssertFalse(mockDataManager.called_completion)
        let _ = await mockDataManager.fetchCurrentSummary(withName: "Rome", withCoordinates: nil)
        XCTAssertTrue(mockDataManager.called_completion)
    }
    
    func test_fetchCityList() async {
        guard let mockDataManager = mockDataManager as? MockDataManager else {
            XCTFail()
            return
        }
        
        XCTAssertFalse(mockDataManager.called_completion)
        
        do {
            let _ = try await mockDataManager.fetchCities([(lat: 41.9102415, long: 12.3959128)])
            XCTAssertTrue(mockDataManager.called_completion)
        } catch {
            XCTFail()
        }
    }
    
    func test_city_serialization() {
        let jsonSummaryString = """
        {
            "coord": {
                "lon": -0.1257,
                "lat": 51.5085
            },
                "weather": [{
                    "id": 802,
                    "main": "Clouds",
                    "description": "scattered clouds",
                    "icon": "03d"
                }],
            "main": {
                "temp": 287.87
                
            },
           
            "clouds": {
                "all": 40
            },
            "dt": 1664191572,
            "sys": {
                "type": 2,
                "id": 268730,
                "country": "GB",
                "sunrise": 1664171560,
                "sunset": 1664214665
            },
            
            "id": 2643743,
            "name": "Rome",
            "cod": 200
        }
        """
        
        if let jsonData = jsonSummaryString.data(using: .utf8) {
            let result = CityNetworkResult.success(jsonData)
            let city = City.deserializeCity(withNetworkResult: result)
            XCTAssertEqual("Rome", city?.name)
        } else {
            XCTFail()
        }
    }
}
