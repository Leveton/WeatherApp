//
//  CityForcastViewModel.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation
import DataManager

class CityForcastViewModel: ObservableObject {
    @Published var city: City
    fileprivate lazy var dataManager: DataManagerProtocol = DataManager.sharedInstance
    
    init(_ city: City) {
        self.city = city
    }
    
    public func fetchForecastWithCoordinates(_ coord: (lat: Double, long: Double)) async {
        let result: Result<Data?, APIManagerError> = await dataManager.fetchFiveDayForcast(withCoordinates: coord)
        switch result {
            case .success(let data):
                guard let data = data else {return}
                do {
                    let city: City = try JSONDecoder().decode(City.self, from: data)
                    DispatchQueue.main.async {
                        self.city = city
                    }
                } catch {
                    //TODO: Surface alert Firebase to the error
                    print("Decoding error::: \(error.localizedDescription)")
                }
                
            //TODO: Surface alert Firebase to the error
            case .failure(let error):
                print("API error::: \(error.localizedDescription)")
        }
    }
    
    public func fetchSummaryWithCoordinates(_ coord: (lat: Double, long: Double)) async {
        let result: Result<Data?, APIManagerError> = await dataManager.fetchCurrentSummary(withCoordinates: coord)
        switch result {
            case .success(let data):
                guard let data = data else {return}
                do {
                    let city: City = try JSONDecoder().decode(City.self, from: data)
                    DispatchQueue.main.async {
                        self.city = city
                    }
                } catch {
                    //TODO: Surface alert Firebase to the error
                    print("Decoding error::: \(error.localizedDescription)")
                }
                
            //TODO: Surface alert Firebase to the error
            case .failure(let error):
                print("API error::: \(error.localizedDescription)")
        }
    }
    
    public func fetchSummaryWithName(_ name: String) async {
        let result: Result<Data?, APIManagerError> = await dataManager.fetchCurrentSummary(withName: name)
        switch result {
            case .success(let data):
                guard let data = data else {return}
                do {
                    let city: City = try JSONDecoder().decode(City.self, from: data)
                    DispatchQueue.main.async {
                        self.city = city
                    }
                } catch {
                    //TODO: Surface alert Firebase to the error
                    print("Decoding error::: \(error.localizedDescription)")
                }
                
            //TODO: Surface alert Firebase to the error
            case .failure(let error):
                print("API error::: \(error.localizedDescription)")
        }
    }
}
