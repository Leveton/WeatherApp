//
//  CityAddViewModel.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/28/22.
//

import Foundation

class CityAddViewModel {
    public lazy var googlePlacesManager: GooglePlacesManagerProtocol = GooglePlacesManager.sharedInstance
    public var didAddCityHandler: ((SimpleCoord) -> Void)?
    public var citiesFoundHandler: (() -> Void)?
    public var cities = [City]()
    
    public func getCoords(forCity city: City) {
        googlePlacesManager.getCoordinatesForCity(city, completion: {[weak self] result in
            switch result {
            case .success(let coord):
                let simpleCoords: SimpleCoord = (lat: coord.latitude, long: coord.longitude)
                
                //Notify the City add controller that a new city was tapped
                self?.didAddCityHandler?(simpleCoords)
                
            case .failure(let error):
                //TODO: surface error
                print("get coord custom error::: \(error)")
            }
        })
    }
    
    public func findPlaces(withQuery query: String) {
        googlePlacesManager.findPlaces(query, completion: {result in
            switch result {
            case .success(let cities):
                DispatchQueue.main.async { [weak self] in
                    self?.cities = cities
                    self?.citiesFoundHandler?()
                }
            case .failure(let error):
                print("places custom error::: \(error.localizedDescription)")
            }
        })
    }
}



