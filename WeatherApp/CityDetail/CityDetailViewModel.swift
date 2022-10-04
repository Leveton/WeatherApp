//
//  CityDetailViewModel.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation
import DataManager
import SwiftUI

class CityDetailViewModel: ObservableObject {
    @Published public var city: City?
    @Published public var showCityList = true
    @Published var isRefreshing = false
    public var cities: [City]?
    public lazy var dataManager: DataManagerProtocol = DataManager.sharedInstance
    public lazy var relationalDataManager: RelationalDataProtocol = RelationalDataManager.sharedInstance
    public var didTapCityListHandler: (() -> Void)?
    public var didPullToRefreshHandler: (() -> Void)?
    
    public func fetchForecastWithCoordinates(_ coord: (lat: Double, long: Double)) async {
        let result: CityNetworkResult = await dataManager.fetchFiveDayForecast(withCoordinates: coord)
        if let freshCity = City.deserializeCity(withNetworkResult: result) {
            DispatchQueue.main.async {
                withAnimation {
                    self.city = freshCity
                }
            }
        }
    }
    
    public func fetchSummaryWithCoordinates(_ coord: SimpleCoord) async {
        let result: CityNetworkResult = await dataManager.fetchCurrentSummary(withName: nil, withCoordinates: coord)
        guard let freshCity = City.deserializeCity(withNetworkResult: result) else {return}
        
        //save to CD
        persistCity(freshCity)
        
        //redraw swiftui
        DispatchQueue.main.async {
            withAnimation {
                self.city = freshCity
            }
        }
    }
    
    public func fetchSummaryWithName(_ name: String) async {
        let result: CityNetworkResult = await dataManager.fetchCurrentSummary(withName: name, withCoordinates: nil)
        guard let freshCity = City.deserializeCity(withNetworkResult: result) else {return}
        
        //save to CD
        persistCity(freshCity)
        
        //redraw swiftui
        DispatchQueue.main.async {
            withAnimation {
                self.city = freshCity
            }
        }
    }
}

//Core Data
extension CityDetailViewModel {
    fileprivate func persistCity(_ city: City) {
        guard let openWeatherID = city.openWeatherID else {return}
        
        let context = relationalDataManager.managedObjectContext
        context.perform {
            //prevent dups
            let predicate = NSPredicate(format: "openWeatherID == %ld", openWeatherID)
            guard self.relationalDataManager.fetchObject(forEntityName: "CityPersisted", in: context, predicate: predicate) == nil else {
                return
            }
            
            let _: [CityPersisted] = [city].compactMap({CityPersisted(withCity: $0, in: context)})
            
            do {
              try context.save()
            } catch let error as NSError {
              print("Could not save persisted city::: \(error), \(error.userInfo)")
            }
        }
    }
}
