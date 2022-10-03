//
//  APIManagerProtocol.swift
//  DataManager
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation
import CoreLocation

//TODO: use this for all City API results
public typealias CityNetworkResult = Result<Data?, APIManagerError>

public protocol APIManagerProtocol {
    var openWeatherAPIKey: String {get}
}

public enum APIManagerService {
    case currentSummary
}

public enum APIManagerError: Error {
    case noData, badRequest, invalidURL
    case failedRequest(error: Error)
}

// MARK: - APIManager Protocol Methods
extension APIManagerProtocol {
    //Find current weather by name or coordinates
    public func fetchCurrentSummary(withName name: String? = nil, withCoordinates coordinates: (lat: Double, long: Double)? = nil) async -> Result<Data?, APIManagerError> {
        
        let url: URL? = {
            if let coord = coordinates {
                return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coord.lat)&lon=\(coord.long)&appid=\(openWeatherAPIKey)")
            } else if let name = name {
                return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(name),us&APPID=\(openWeatherAPIKey)")
            }
            return nil
        }()
        
        guard let cityURL = url else {
            return .failure(.invalidURL)
        }
        
        do {
            let data = try await URLSession.shared.data(from: cityURL).0
            return .success(data)
        } catch {
            return .failure(.failedRequest(error: error))
        }
    }
    
    //Find 5 day / 3 hour forecast data
    public func fetchFiveDayForecast(withCoordinates coordinates: (lat: Double, long: Double)) async -> Result<Data?, APIManagerError> {
        guard let cityURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinates.lat)&lon=\(coordinates.long)&appid=\(openWeatherAPIKey)") else {
            return .failure(.invalidURL)
        }
        
        do {
            let data = try await URLSession.shared.data(from: cityURL).0
            return .success(data)
        } catch {
            return .failure(.failedRequest(error: error))
        }
    }
    
    //TODO: Fallback to city name if there's no coordinate
    public func fetchCities(_ cityCoordinates: [(lat: Double, long: Double)]) async throws -> [Data] {
        
        return try await withThrowingTaskGroup(of: CityNetworkResult.self) { taskGroup in
            var dataArray =  [Data]()
            
            for coord in cityCoordinates {
              taskGroup.addTask {
                  return await self.fetchCurrentSummary(withCoordinates: (lat: coord.lat, long: coord.long))
              }
            }
            
            for try await cityResult in taskGroup {
                switch cityResult {
                case .success(let data):
                    if let data = data {
                        dataArray.append(data)
                    }
                case .failure(let error):
                    print("fetch cities custom error::: \(error)")
                }
            }
            return dataArray
          }
        }
}
