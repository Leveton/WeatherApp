//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/26/22.
//

import Foundation
import DataManager
import SwiftUI

class CityListViewModel: ObservableObject {
    @Published public var cities: [City]?
    public lazy var dataManager: DataManagerProtocol = DataManager.sharedInstance
    public var didTapAddCityHandler: (() -> Void)?
    public var didTapCityDetailHandler: ((City) -> Void)?
    public var didPullToRefreshHandler: (() -> Void)?
    
    public var homeCity: City? {
        didSet {
            //If the data source hasn't been initialized, at least show the home city
            if let homeCity = homeCity, cities == nil {
                withAnimation {
                    cities = [homeCity]
                }
            }
        }
    }
    
    public func addCity(forCoordinates coords: SimpleCoord) {
        //prevent dups
        for city in cities ?? [] {
            guard let simpleCoord = city.simpleCoord else {continue}
            if simpleCoord == coords {
               return
            }
        }
        
        Task {
            if let updatedCities = await addCityAsync(forCoordinates: coords) {
                DispatchQueue.main.async {[weak self] in
                    //redraw SwiftUI
                    withAnimation {
                        self?.cities = updatedCities
                    }
                }
            }
        }
    }
    
    public func addCityAsync(forCoordinates coords: SimpleCoord) async -> [City]? {
        let result: CityNetworkResult = await dataManager.fetchCurrentSummary(withCoordinates: coords)
        if let freshCity = City.deserializeCity(withNetworkResult: result) {
            var currentCities = cities ?? [City]()
            currentCities.append(freshCity)
            return currentCities
            
        }
        
        return nil
    }
    
    public func fetchCities() {
        Task {
            if let updatedCities = await fetchCitiesAsync() {
                DispatchQueue.main.async {[weak self] in
                    //redraw swiftUI views
                    self?.cities = updatedCities
                }
            }
        }
    }
    
    public func fetchCitiesAsync() async -> [City]? {
        guard let cities = cities else {return nil}
        let coordinates: [(lat: Double, long: Double)] = cities.compactMap({$0.simpleCoord})
        var updatedCities = [City]()
        
        do {
            let dataArray = try await dataManager.fetchCities(coordinates)
            
            for data in dataArray {
                do {
                    let city: City = try JSONDecoder().decode(City.self, from: data)
                    updatedCities.append(city)
                } catch {
                    print("Decoding error::: \(error.localizedDescription)")
                }
            }

        } catch {
            //TODO: surface error
        }
        
        return updatedCities
    }
}
