//
//  MockDataManagerProtocol.swift
//  DataManagerTests
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation
@testable import DataManager
@testable import WeatherApp

class MockDataManager: DataManagerProtocol {
    var called_completion = false
    var passed_error: Error?
    var apiManager: APIManagerProtocol = MockAPIManager()
    
    func fetchCities(_ cityCoordinates: [(lat: Double, long: Double)]) async throws -> [Data] {
        guard let first = cityCoordinates.first else {
            throw APIManagerError.noData
        }
        var rome = City(name: "Rome")
        rome.lat = first.lat
        rome.lon = first.long
        let data: Data = try JSONEncoder().encode(rome)
        return [data]
    }
    
    func fetchCurrentSummary(withName name: String?, withCoordinates coordinates: (lat: Double, long: Double)?) async -> Result<Data?, APIManagerError> {
        
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
            if let coordinates = coordinates {
                var rome = City(name: "Rome")
                rome.lat = coordinates.lat
                rome.lon = coordinates.long
                do {
                    let data: Data = try JSONEncoder().encode(rome)
                    return .success(data)
                } catch {
                    return .failure(APIManagerError.badRequest)
                }
            } else if let name = name {
                let rome = City(name: name)
                
                do {
                    let data: Data = try JSONEncoder().encode(rome)
                    return .success(data)
                } catch {
                    return .failure(APIManagerError.badRequest)
                }
            } else {
                return .failure(APIManagerError.noData)
            }
        } else {
            return .failure(APIManagerError.noData)
        }
            
        
    }
}
