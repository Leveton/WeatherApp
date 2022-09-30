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
                        Text("Popular Cities")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom("SanFranciscoRounded-Regular", size: 25))
                            .padding([.leading], 10)
                            .background(.white)
                        Button {
                            print("Edit button was tapped")
            
                        } label: {
                            Image(systemName: "plus")
                        }
                        .padding([.trailing], 10)
                    }
                }
                ForEach(cities, id: \.uuid) { entry in
                    CityRowView(entry: entry)
                }
                .onDelete(perform: self.deleteItems)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                print("Do your refresh work here")
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
    let entry: City
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                if let temperature = entry.temp, let fahrenheit = temperature.fahrenheit {
                    Text(entry.name + " " + "\(Int(fahrenheit))º")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("SanFranciscoRounded-Regular", size: 17))
                        .padding([.leading], 10)
                } else {
                    Text(entry.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("SanFranciscoRounded-Regular", size: 17))
                        .padding([.leading], 10)
                }
                
                let desc = entry.description ?? "Conditions currently unavailable"
                Text(desc)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("SanFranciscoRounded-Regular", size: 17))
                    .padding([.leading], 10)
            }
            Image(systemName: "chevron.forward")
                .padding([.trailing], 10)
        }
    }
}
