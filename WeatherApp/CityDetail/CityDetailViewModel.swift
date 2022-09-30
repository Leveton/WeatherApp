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
        
        if let freshCity = City.deserializeCity(withNetworkResult: result) {
            
            DispatchQueue.main.async {
                withAnimation {
                    self.city = freshCity
                }
            }
        }
    }
    
    public func fetchSummaryWithName(_ name: String) async {
        let result: CityNetworkResult = await dataManager.fetchCurrentSummary(withName: name, withCoordinates: nil)
        if let freshCity = City.deserializeCity(withNetworkResult: result) {
            DispatchQueue.main.async {
                withAnimation {
                    self.city = freshCity
                }
            }
        }
    }
}
