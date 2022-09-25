//
//  DataManager.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation
import DataManager

open class DataManager: DataManagerProtocol {
    public var apiManager: APIManagerProtocol = APIManager.sharedInstance
    
    static let sharedInstance = DataManager()
}
