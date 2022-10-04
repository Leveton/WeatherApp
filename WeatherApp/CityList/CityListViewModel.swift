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
    public lazy var relationalDataManager: RelationalDataProtocol = RelationalDataManager.sharedInstance
    public var didTapAddCityHandler: (() -> Void)?
    public var didTapCityDetailHandler: ((City) -> Void)?
    public var didPullToRefreshHandler: (() -> Void)?
    
    init() {
        loadPersistedCities()
    }
    
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
        //let fl = Float(coords.long)
        guard (cities ?? []).first(where: {$0.lat == coords.lat && $0.lon == coords.long}) == nil else {
            return
        }
        
        Task {
            if let freshCity: City = await addCityAsync(forCoordinates: coords) {
                //Save to CD
                persistCities([freshCity])
                
                //redraw SwiftUI
                updateCities(withCity: freshCity)
            }
        }
    }
    
    public func addCityAsync(forCoordinates coords: SimpleCoord) async -> City? {
        let result: CityNetworkResult = await dataManager.fetchCurrentSummary(withName: nil, withCoordinates: coords)
        return City.deserializeCity(withNetworkResult: result)
    }
    
    public func fetchCities() {
        Task {
            if let updatedCities = await fetchCitiesAsync() {
                
                //Save to CD
                persistCities(updatedCities)
                
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
        var updatedCities = cities
        
        do {
            let dataArray = try await dataManager.fetchCities(coordinates)
            
            for data in dataArray {
                do {
                    let city: City = try JSONDecoder().decode(City.self, from: data)
                    //prevent dups
                    if cities.first(where: {$0 == city}) == nil {
                        print("fetch cities openweather ID::: \(city.openWeatherID)")
                        updatedCities.append(city)
                    }
                } catch {
                    print("Decoding custom error::: \(error.localizedDescription)")
                }
            }

        } catch {
            //TODO: surface error
        }
        
        return updatedCities
    }
    
    fileprivate func updateCities(withCity city: City) {
        var currentCities = cities ?? [City]()
        guard currentCities.first(where: {$0 == city}) == nil else {return}
        currentCities.append(city)
        
        //redraw SwiftUI
        DispatchQueue.main.async {[weak self] in
            withAnimation {
                self?.cities = currentCities
            }
        }
    }

}

//MARK: core data
extension CityListViewModel {
    fileprivate func persistCities(_ cities: [City]) {
        let context = relationalDataManager.managedObjectContext
        context.perform {
            let _: [CityPersisted] = cities.compactMap({CityPersisted(withCity: $0, in: context)})
            
            do {
              try context.save()
            } catch let error as NSError {
              print("Could not save persisted city::: \(error), \(error.userInfo)")
            }
        }
    }
    
    fileprivate func loadPersistedCities() {
        let context = relationalDataManager.managedObjectContext
        
        context.perform {
            let result = self.relationalDataManager.fetchAllObjects(forEntityName: "CityPersisted", in: context, optionalPredicate: nil)
            
            switch result {
            case .success(let objects):
                if let cities = objects as? [CityPersisted] {
                    let internalCities = cities.compactMap({City(withCityPersisted: $0)})
                    
                    //prevent dups
                    //let citySet: Set = Set(internalCities)
                    
                    //Redraw SwiftUI
                    DispatchQueue.main.async {[weak self] in
                        self?.cities = internalCities
                    }
                }
            case .failure(let error):
                print("load persisted cities custom error::: \(error.localizedDescription)")
            }
        }
    }
}
