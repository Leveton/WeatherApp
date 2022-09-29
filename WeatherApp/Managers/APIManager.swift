//
//  APIManager.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import Foundation
import DataManager

open class APIManager: APIManagerProtocol {
    static let sharedInstance = APIManager()
    
    //TODO: Keep this as a protocol for API testing, but it's value should be stored in the user's KeyChain and rotated via the server
    public let openWeatherAPIKey = "5855a2848bc9b48e31ae7a75e357201c"
}
