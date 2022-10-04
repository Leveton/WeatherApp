//
//  CityPersisted+CoreDataClass.swift
//  WeatherApp
//
//  Created by Michael Leveton on 10/3/22.
//
//

import Foundation
import CoreData

@objc(CityPersisted)
public class CityPersisted: NSManagedObject {
    
    public convenience init?(withCity city: City, in context: NSManagedObjectContext) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "CityPersisted", in: context) else {
            return nil
        }
        self.init(entity: entityDescription, insertInto: context)
        
        self.name = city.name
        self.country = city.country
        self.descriptionString = city.description
        if let internalFeelsLike = city.feelsLike {
            self.feelsLike = NSDecimalNumber(value: internalFeelsLike)
            print("CD serialzed float feels like::: \(self.feelsLike) original \(internalFeelsLike)")
        }
        self.googlePlacesID = city.googlePlacesID
        if let humidity = city.humidity {
            self.humidity = NSNumber(value: humidity)
        }
        if let lat = city.lat {
            self.lat = NSDecimalNumber(value: lat)
            print("CD serialzed double lat::: \(self.lat) original \(lat)")
        }
        if let lon = city.lon {
            self.lon = NSDecimalNumber(floatLiteral: lon)
            print("CD serialzed double lon::: \(self.lon) original \(lon)")
        }
        if let openWeatherID = city.openWeatherID {
            self.openWeatherID = NSNumber(value: openWeatherID)
            print("CD serialzed Int openWeatherID::: \(self.openWeatherID) original \(openWeatherID)")
        }
        if let sunrise = city.sunrise {
            self.sunrise = NSNumber(value: sunrise)
        }
        if let sunset = city.sunset {
            self.sunset = NSNumber(value: sunset)
        }
        if let temp = city.temp {
            self.temp = NSDecimalNumber(value: temp)
        }
        if let timezone = city.timezone {
            self.timezone = NSNumber(value: timezone)
        }
        if let tempMax = city.tempMax {
            self.tempMax = NSDecimalNumber(value: tempMax)
        }
        if let tempMin = city.tempMin {
            self.tempMin = NSDecimalNumber(value: tempMin)
        }
        if let windSpeed = city.windSpeed {
            let windDouble = Double(windSpeed)
            self.windSpeed = NSDecimalNumber(floatLiteral: windDouble)
            print("CD serialzed float windSpeed::: \(self.windSpeed) original \(windSpeed) tempWind")
        }
    }
}
