//
//  APIManagerProtocol.swift
//  DataManager
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation

public protocol APIManagerProtocol {
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
    
    //Find current weather by name or lat-long
    public func fetchCurrentSummary(withName name: String? = nil, withCoordinates coordinates: (lat: Double, long: Double)? = nil) async -> Result<Data?, APIManagerError> {
        //https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid=5855a2848bc9b48e31ae7a75e357201c
        guard let cityURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Miami,us&APPID=5855a2848bc9b48e31ae7a75e357201c") else {
            return .failure(.invalidURL)
        }
        
        if let _ = name {
            
            do {
                let data = try await URLSession.shared.data(from: cityURL).0
                return .success(data)
            } catch {
                return .failure(.failedRequest(error: error))
            }
            
            
        } else if let _ = coordinates {
            
            do {
                let data = try await URLSession.shared.data(from: cityURL).0
                return .success(data)
            } catch {
                return .failure(.failedRequest(error: error))
            }
        } else {
            return .failure(.noData)
        }
    }
    
    //Find 5 day / 3 hour forecast data
    public func fetchFiveDayForcast(withCoordinates coordinates: (lat: Double, long: Double)? = nil) async -> Result<Data?, APIManagerError> {
        guard let cityURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Miami,us&APPID=5855a2848bc9b48e31ae7a75e357201c") else {
            return .failure(.invalidURL)
        }
        
        if let _ = coordinates {
            
            do {
                let data = try await URLSession.shared.data(from: cityURL).0
                return .success(data)
            } catch {
                return .failure(.failedRequest(error: error))
            }
        } else {
            return .failure(.noData)
        }
    }
}
