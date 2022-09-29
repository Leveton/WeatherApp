//
//  CityForcastViewModel.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation

class CityForcastViewModel: ObservableObject {
    @Published var city: City
    
    init(_ city: City) {
        self.city = city
    }
}
