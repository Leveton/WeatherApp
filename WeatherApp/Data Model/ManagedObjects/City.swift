//
//  City.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/26/22.
//

import Foundation

struct City: Codable {
    //TODO: Use CLLocationCoordinate2D
    var lat: Double
    var lon: Double
   
    //var coord: CLLocationCoordinate2D
    var weather: Weather
    var description: String
    var name: String
    var country: String
    var temp: Float
    var feelsLike: Float
    var tempMin: Float
    var tempMax: Float
    var windSpeed: Float
    var humidity: Int
    var timezone: Int
    var sunrise: Int
    var sunset: Int
    
    struct Weather: Codable {
        var id: Int
        var main: String
        var description: String
        var name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, description, name, timezone, temp, humidity, country, sunrise, sunset, weather
        case feelsLike = "feels_like"
        case windSpeed = "speed"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //let rawResponse = try City(from: decoder)
        self.weather = try container.decode(Weather.self, forKey: .weather)
        //self.coord = try container.decode(CLLocationCoordinate2D.self, forKey: .coord)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.timezone = try container.decode(Int.self, forKey: .timezone)
        self.sunrise = try container.decode(Int.self, forKey: .sunrise)
        self.sunset = try container.decode(Int.self, forKey: .sunset)
        self.windSpeed = try container.decode(Float.self, forKey: .windSpeed)
        self.tempMax = try container.decode(Float.self, forKey: .tempMax)
        self.tempMin = try container.decode(Float.self, forKey: .tempMin)
        self.feelsLike = try container.decode(Float.self, forKey: .feelsLike)
        self.temp = try container.decode(Float.self, forKey: .temp)
        self.country = try container.decode(String.self, forKey: .country)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
    }
}

//extension CLLocationCoordinate2D: Decodable {
//    public init(from decoder: Decoder) throws {
//
//    }
//}
