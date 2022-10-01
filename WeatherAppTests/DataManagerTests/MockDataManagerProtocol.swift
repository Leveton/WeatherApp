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
        called_completion = true
        return [data]
    }
    
    func fetchCurrentSummary(withName name: String?, withCoordinates coordinates: (lat: Double, long: Double)?) async -> Result<Data?, APIManagerError> {
    
        if let coordinates = coordinates {
            var rome = City(name: "Rome")
            rome.lat = coordinates.lat
            rome.lon = coordinates.long
            do {
                let data: Data = try JSONEncoder().encode(rome)
                called_completion = true
                return .success(data)
            } catch {
                return .failure(APIManagerError.badRequest)
            }
        } else if let name = name {
            let rome = City(name: name)
            
            do {
                let data: Data = try JSONEncoder().encode(rome)
                called_completion = true
                return .success(data)
            } catch {
                return .failure(APIManagerError.badRequest)
            }
        } else {
            return .failure(APIManagerError.noData)
        }
    }
}
