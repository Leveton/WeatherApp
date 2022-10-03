//
//  MockGoogleManagerProtocol.swift
//  WeatherAppTests
//
//  Created by Michael Leveton on 9/30/22.
//

import Foundation
import CoreLocation

@testable import DataManager
@testable import WeatherApp

class MockGoogleManager: GooglePlacesManagerProtocol {
    var called_completion = false
    var passed_error: Error?
    
    func findPlaces(_ query: String, completion: @escaping (Result<[WeatherApp.City], Error>) -> Void) {
        let city1 = City(name: "London")
        let city2 = City(name: "Rome")
        let cities = [city1, city2]
        completion(.success(cities))
        
        called_completion = true
    }
    
    func getCoordinatesForCity(_ city: WeatherApp.City, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        if city.name == "Rome" {
            completion(.success(CLLocationCoordinate2D(latitude: 41.9102415, longitude: 12.3959128)))
            called_completion = true
        } else {
            completion(.failure(APIManagerError.badRequest))
            called_completion = false
        }
    }
    
    
}
