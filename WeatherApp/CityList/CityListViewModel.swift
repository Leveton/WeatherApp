//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/26/22.
//

import Foundation
import DataManager

class CityListViewModel: ObservableObject {
    @Published public var cities: [City]?
    fileprivate lazy var dataManager: DataManagerProtocol = DataManager.sharedInstance
    
    public var homeCity: City? {
        didSet {
            //If the data source hasn't been initialized, at least show the home city
            if let homeCity = homeCity, cities == nil {
                cities = [homeCity]
            }
        }
    }
    
    public func fetchCities() {
        Task {
            if let updatedCities = await refreshCities() {
                DispatchQueue.main.async {[weak self] in
                    //redraw swift ui views
                    self?.cities = updatedCities
                }
            }
        }
    }
    
    private func refreshCities() async -> [City]? {
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
