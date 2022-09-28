//
//  City.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/26/22.
//

import Foundation

protocol WeatherProtocol {
    var fahrenheit: Float? {get}
}

struct City {

    //MARK: Required
    let uuid = UUID()
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

}

extension City: Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
        if lhs.name == rhs.name && lhs.lat == rhs.lat && lhs.lon == rhs.lon {
            return true
        }
        
        return false
    }
}

extension City: Codable {

    init(from decoder: Decoder) throws {
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
}

//MARK: methods and computed properties
extension City: WeatherProtocol {
    var fahrenheit: Float? {
        guard let kelvin = self.temp else {return nil}
        return (kelvin - 273.15) * 9/5 + 32
    }
}

//extension CLLocationCoordinate2D: Decodable {
//    public init(from decoder: Decoder) throws {
//
//    }
//}

fileprivate let cityStaticDict = ["Brooklyn": City(name: "Brooklyn",
                                        lat: 40.6593564,
                                        lon: -73.9501857),
                            "London": City(name: "London",
                                        lat: 51.5287352,
                                        lon: -0.3817815),
                            "Manhattan": City(name: "Manhattan",
                                        lat: 40.7647242,
                                        lon: -73.9844751),
                            "Los Angeles": City(name: "Los Angeles",
                                        lat: 34.0207305,
                                        lon: -118.6919255),
                            "Buenos Aires": City(name: "Buenos Aires",
                                        lat: -34.6156625,
                                        lon: -58.5033386),
                            "Lisbon": City(name: "Lisbon",
                                        lat: 38.7437396,
                                        lon: -9.2302436),
                            "Paris": City(name: "Paris",
                                        lat: 48.8589466,
                                        lon: 2.276995),
                            "Berlin": City(name: "Berlin",
                                        lat: 52.5027377,
                                        lon: 12.341775),
                            "Madrid": City(name: "Madrid",
                                        lat: 40.4381311,
                                        lon: -3.8196219),
                            "Rome": City(name: "Rome",
                                        lat: 41.9102415,
                                        lon: 12.3959128),
                            "Kyiv": City(name: "Kyiv",
                                        lat: 50.4021368,
                                        lon: 30.252507),
                            "Athens": City(name: "Athens",
                                        lat: 37.9908997,
                                        lon: 23.7033198),
                            "Tokyo": City(name: "Tokyo",
                                        lat: 35.5062901,
                                        lon: 138.6485527),
                            "Warsaw": City(name: "Warsaw",
                                        lat: 52.2330653,
                                        lon: 20.9211106)
                                  
]
