//
//  Constants.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/29/22.
//

import Foundation

//MARK: segues
let cityDetailControllerToCityListController = "cityDetailControllerToCityListController"
let cityListControllerToCityAddController = "cityListControllerToCityAddController"

//TODO: This should be stored in the user's KeyChain and rotated via the server
let googlePlacesAPIKey = "AIzaSyBCgO7OTTIn-J4cgnCsaCqthgbbz4ELVt4"

let cityStaticDict = ["Brooklyn": City(name: "Brooklyn",
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
