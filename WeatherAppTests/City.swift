//
//  City.swift
//  WeatherAppTests
//
//  Created by Michael Leveton on 9/27/22.
//

import XCTest
@testable import WeatherApp

final class CityDataModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoding() throws {
        let jsonString = """
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
            "base": "stations",
            "main": {
                "temp": 287.87
            },
            "id": 2643743,
            "name": "London",
            "cod": 200
        }
        """
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("can't parse json")
            return
        }
        
        let decoder = JSONDecoder()
        guard let decodedCity = try? decoder.decode(City.self, from: jsonData) else {
            XCTFail("can't decode city")
            return
        }
        
        var city = City(
            id: 2643743,
            name: "London",
            temp: 287.87,
            lat: 51.5085,
            lon: -0.1257
        )
        
        XCTAssertNotEqual(city, decodedCity)
        
        let weatherElement = City.Weather(description: "scattered clouds")
        city.description = weatherElement.description
        XCTAssertEqual(city, decodedCity)
    }

}

