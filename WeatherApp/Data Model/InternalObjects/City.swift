//
//  City.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/26/22.
//

import Foundation
import CoreLocation
import DataManager
import CoreData

//TODO: use this for all simple coords
typealias SimpleCoord = (lat: Double, long: Double)

protocol WeatherProtocol {
    var coord: CLLocationCoordinate2D? {get}
    
    //In case you don't want to import CoreLocation
    var simpleCoord: SimpleCoord? {get}
}

public struct City {

    //MARK: Required
    let uuid = UUID().uuidString
    var name: String
    
    //MARK: Optional
    var lat: Double? //TODO: Use CLLocationCoordinate2D
    var lon: Double?
    var openWeatherID: Int?
    var googlePlacesID: String?
    var temp: Float?
    var timezone: Int?
    var humidity: Int?
    var tempMin: Float?
    var tempMax: Float?
    var feelsLike: Float?
    var windSpeed: Float?
    var sunrise: Int?
    var sunset: Int?
    var country: String?
    var description: String?
    
    enum RootKeys: String, CodingKey {
        case id, name, timezone
        case main, wind, sys, coord, weather
    }

    enum MainKeys: String, CodingKey {
        case humidity, temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case feelsLike = "feels_like"
    }
    
    enum WindKeys: String, CodingKey {
        case windSpeed = "speed"
    }
    
    enum SysKeys: String, CodingKey {
        case sunrise, sunset, country
    }

    enum CoordKeys: String, CodingKey {
        case lon, lat
    }
    
    struct Weather: Codable {
        var description: String?
        enum RootKeys: String, CodingKey {
            case description
        }
    }

    static func deserializeCity(withNetworkResult result: CityNetworkResult) -> City? {
        switch result {
            case .success(let data):
                guard let data = data else {return nil}
                
                do {
                    return try JSONDecoder().decode(City.self, from: data)
                } catch {
                    //TODO: Surface alert Firebase to the error
                    return nil
                }
                
            //TODO: Surface alert Firebase to the error
        case .failure(_):
            return nil
        }
    }
}

extension City: Equatable {
    public static func == (lhs: City, rhs: City) -> Bool {
        if lhs.name == rhs.name && lhs.lat == rhs.lat && lhs.lon == rhs.lon {
            return true
        }
        
        return false
    }
}

extension City: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        openWeatherID = try? container.decode(Int.self, forKey: .id)
        timezone = try? container.decode(Int.self, forKey: .timezone)
        name = try container.decode(String.self, forKey: .name)

        let mainContainer = try? container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        humidity = try? mainContainer?.decode(Int.self, forKey: .humidity)
        tempMin = try? mainContainer?.decode(Float.self, forKey: .tempMin)
        tempMax = try? mainContainer?.decode(Float.self, forKey: .tempMax)
        temp = try? mainContainer?.decode(Float.self, forKey: .temp)
        feelsLike = try? mainContainer?.decode(Float.self, forKey: .feelsLike)
        
        let windContainer = try? container.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        windSpeed = try? windContainer?.decode(Float.self, forKey: .windSpeed)
        
        let sysContainer = try? container.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)
        sunrise = try? sysContainer?.decode(Int.self, forKey: .sunrise)
        sunset = try? sysContainer?.decode(Int.self, forKey: .sunset)
        country = try? sysContainer?.decode(String.self, forKey: .country)
        
        let coordContainer = try? container.nestedContainer(keyedBy: CoordKeys.self, forKey: .coord)
        lat = try? coordContainer?.decode(Double.self, forKey: .lat)
        lon = try? coordContainer?.decode(Double.self, forKey: .lon)
        
        let weatherContainer = try? container.decode([Weather].self, forKey: .weather).first
        description = weatherContainer?.description
    }
    
    //Serialize from Core Data to a lightweight struct
    //Passing raw CD objects around the app is not thread safe
    init(withCityPersisted cityPersisted: CityPersisted) {
        
        self.name = cityPersisted.name ?? ""
        self.country = cityPersisted.country
        self.description = cityPersisted.descriptionString
        self.feelsLike = cityPersisted.feelsLike?.floatValue
        self.googlePlacesID = cityPersisted.googlePlacesID
        self.humidity = cityPersisted.humidity?.intValue
        self.lat = cityPersisted.lat?.doubleValue
        self.lon = cityPersisted.lon?.doubleValue
        self.openWeatherID = cityPersisted.openWeatherID?.intValue
        self.sunrise = cityPersisted.sunrise?.intValue
        self.sunset = cityPersisted.sunset?.intValue
        self.temp = cityPersisted.temp?.floatValue
        self.timezone = cityPersisted.timezone?.intValue
        self.tempMax = cityPersisted.tempMax?.floatValue
        self.tempMin = cityPersisted.tempMin?.floatValue
        self.windSpeed = cityPersisted.windSpeed?.floatValue
        
    }
}

//MARK: methods and computed properties
extension City: WeatherProtocol {
    var coord: CLLocationCoordinate2D? {
        guard let lat = lat, let lon = lon else {return nil}
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    var simpleCoord: SimpleCoord? {
        guard let lat = lat, let lon = lon else {return nil}
        return (lat: lat, long: lon)
    }
}


extension Float {
    var fahrenheit: Float {
        return (self - 273.15) * 9/5 + 32
    }
}
