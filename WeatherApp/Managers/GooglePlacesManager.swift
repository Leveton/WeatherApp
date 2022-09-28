//
//  GooglePlacesManager.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/28/22.
//

import Foundation
import GooglePlaces
import CoreLocation

protocol GooglePlacesManagerProtocol {
    func findPlaces(_ query: String, completion: @escaping (Result<[City], Error>) -> Void)
    func getCoordinatesForCity(_ city: City, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void)
}

enum GooglePlacesError: Error {
    case placeCoordinatesNotFound, placePredictionNotFound, googlePlaceIDNotFound
}

open class GooglePlacesManager: GooglePlacesManagerProtocol {
    static let sharedInstance = GooglePlacesManager()
    private let placesClient = GMSPlacesClient.shared()
    
    func findPlaces(_ query: String, completion: @escaping (Result<[City], Error>) -> Void) {
        let filter = GMSAutocompleteFilter()
        
        filter.types = ["geocode"]
        placesClient.findAutocompletePredictions(fromQuery: query, filter: nil, sessionToken: nil, callback: {results, error in
            guard let results = results, error == nil else {
                completion(.failure(GooglePlacesError.placePredictionNotFound))
                return
            }
            
            let cities: [City] = results.compactMap({
                City(name: $0.attributedFullText.string, googlePlacesID: $0.placeID)
            })
            
            completion(.success(cities))
        })
    }
    
    func getCoordinatesForCity(_ city: City, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        guard let googlePlacesID = city.googlePlacesID else {
            completion(.failure(GooglePlacesError.googlePlaceIDNotFound))
            return
        }
        
        placesClient.fetchPlace(fromPlaceID: googlePlacesID, placeFields: .coordinate, sessionToken: nil, callback: {googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(GooglePlacesError.placeCoordinatesNotFound))
                return
            }
             
            let coord = CLLocationCoordinate2D(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
            completion(.success(coord))
            //let loc = CLLocation(coordinate: coord)
        })
    }
}
