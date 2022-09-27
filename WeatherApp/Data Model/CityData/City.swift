//
//  City.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/26/22.
//

import Foundation

struct City: Equatable {

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

    //MARK: Required
    let id: Int
    var name: String
    var temp: Float
    //TODO: Use CLLocationCoordinate2D
    var lat: Double
    var lon: Double
    
    //MARK: Optional
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
}

extension City: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        timezone = try? container.decode(Int.self, forKey: .timezone)
        name = try container.decode(String.self, forKey: .name)

        let mainContainer = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        humidity = try? mainContainer.decode(Int.self, forKey: .humidity)
        tempMin = try? mainContainer.decode(Float.self, forKey: .tempMin)
        tempMax = try? mainContainer.decode(Float.self, forKey: .tempMax)
        temp = try mainContainer.decode(Float.self, forKey: .temp)
        feelsLike = try? mainContainer.decode(Float.self, forKey: .feelsLike)
        
        let windContainer = try? container.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        windSpeed = try? windContainer?.decode(Float.self, forKey: .windSpeed)
        
        let sysContainer = try? container.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)
        sunrise = try? sysContainer?.decode(Int.self, forKey: .sunrise)
        sunset = try? sysContainer?.decode(Int.self, forKey: .sunset)
        country = try? sysContainer?.decode(String.self, forKey: .country)
        
        let coordContainer = try container.nestedContainer(keyedBy: CoordKeys.self, forKey: .coord)
        lat = try coordContainer.decode(Double.self, forKey: .lat)
        lon = try coordContainer.decode(Double.self, forKey: .lon)
        
        let weatherContainer = try? container.decode([Weather].self, forKey: .weather).first
        description = weatherContainer?.description
    }
}

//extension CLLocationCoordinate2D: Decodable {
//    public init(from decoder: Decoder) throws {
//
//    }
//}
