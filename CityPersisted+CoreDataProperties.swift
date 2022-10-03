//
//  CityPersisted+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Michael Leveton on 10/3/22.
//
//

import Foundation
import CoreData


extension CityPersisted {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityPersisted> {
        return NSFetchRequest<CityPersisted>(entityName: "CityPersisted")
    }

    @NSManaged public var country: String?
    @NSManaged public var descriptionString: String?
    @NSManaged public var feelsLike: NSDecimalNumber?
    @NSManaged public var googlePlacesID: String?
    @NSManaged public var humidity: NSNumber?
    @NSManaged public var lat: NSDecimalNumber?
    @NSManaged public var lon: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var openWeatherID: NSNumber?
    @NSManaged public var sunrise: NSNumber?
    @NSManaged public var sunset: NSNumber?
    @NSManaged public var temp: NSDecimalNumber?
    @NSManaged public var tempMax: NSDecimalNumber?
    @NSManaged public var tempMin: NSDecimalNumber?
    @NSManaged public var timezone: NSNumber?
    @NSManaged public var uuidString: String?
    @NSManaged public var windSpeed: NSDecimalNumber?

}

extension CityPersisted : Identifiable {

}
