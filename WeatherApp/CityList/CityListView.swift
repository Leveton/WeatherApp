//
//  CityListView.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/26/22.
//

import UIKit
import SwiftUI

struct CityListView: View {
    @ObservedObject public var viewModel: CityListViewModel
    
    func deleteItems(at offsets: IndexSet) {
        viewModel.cities?.remove(atOffsets: offsets)
    }
    
    var body: some View {
        if let cities = viewModel.cities {
            List {
                Section {
                    HStack{
                        Text("Your Cities")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom("SanFranciscoRounded-Regular", size: 25))
                            .padding([.leading], 10)
                        Button {
                            viewModel.didTapAddCityHandler?()
            
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(Color(red: 51.0/255.0, green: 51.0/255.0, blue: 255.0/255.0))
                        }
                        .padding([.trailing], 10)
                    }
                }
                Section {
                    ForEach(cities, id: \.uuid) { city in
                        Button {
                            viewModel.didTapCityDetailHandler?(city)
            
                        } label: {
                            CityRowView(city: city)
                        }
                    }
                    .onDelete(perform: self.deleteItems)
                    
                }
            }
            .listStyle(GroupedListStyle())
            .refreshable {
                viewModel.didPullToRefreshHandler?()
            }
            
        } else {
            VStack {
                Spacer()
                Text("Please add a city")
                    .font(.custom("SanFranciscoRounded-Regular", size: 25))
                Spacer()
            }
        }
    }
}

struct CityRowView: View {
    let city: City
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                if let temperature = city.temp, let fahrenheit = temperature.fahrenheit {
                    Text(city.name + " " + "\(Int(fahrenheit))º")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("SanFranciscoRounded-Regular", size: 17))
                        .foregroundColor(Color(red: 51.0/255.0, green: 51.0/255.0, blue: 255.0/255.0))
                        .padding([.leading], 10)
                } else {
                    Text(city.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("SanFranciscoRounded-Regular", size: 17))
                        .foregroundColor(Color(red: 51.0/255.0, green: 51.0/255.0, blue: 255.0/255.0))
                        .padding([.leading], 10)
                }
                
                let desc = city.description ?? "Conditions currently unavailable"
                Text(desc)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("SanFranciscoRounded-Regular", size: 17))
                    .foregroundColor(Color(red: 51.0/255.0, green: 51.0/255.0, blue: 255.0/255.0))
                    .padding([.leading], 10)
            }
            Image(systemName: "chevron.forward")
                .padding([.trailing], 10)
                .foregroundColor(Color(red: 51.0/255.0, green: 51.0/255.0, blue: 255.0/255.0))
        }
    }
}
