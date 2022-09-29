//
//  CityForcastView.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import UIKit
import SwiftUI

struct CityForcastView: View {
    @ObservedObject var viewModel: CityForcastViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    
                    Button {
                        print("Edit button was tapped")
                        
                    } label: {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(Color(red: 51.0/255.0, green: 51.0/255.0, blue: 255.0/255.0))
                    .padding([.trailing, .leading,], 10)
                    .padding([.bottom,], 5)
                    
                    
                    Text(viewModel.city.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("SanFranciscoRounded-Bold", size: 37))
                        .foregroundColor(Color(red: 51.0/255.0, green: 51.0/255.0, blue: 255.0/255.0))
                        .padding([.trailing, .leading], 10)
                    
                    Spacer()
                    let computedTempText: String? = {
                        if let temp = viewModel.city.temp?.fahrenheit, let feels = viewModel.city.feelsLike?.fahrenheit {
                            return "It's \(Int(temp))º, but it feels like \(Int(feels))º"
                        } else if let temp = viewModel.city.temp?.fahrenheit {
                            return "It's currently \(Int(temp))º"
                        }
                        return nil
                    }()
                    
                    if let tempText = computedTempText {
                        Text(tempText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom("SanFranciscoRounded-Bold", size: 32))
                            .foregroundColor(Color(red: 77.0/255.0, green: 77.0/255.0, blue: 255.0/255.0))
                            .padding([.trailing, .leading], 10)
                    }
                    
                    Spacer()
                    if let desc = viewModel.city.description {
                        Text("Conditions are \(desc)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom("SanFranciscoRounded-Bold", size: 27))
                            .foregroundColor(Color(red: 102.0/255.0, green: 102.0/255.0, blue: 255.0/255.0))
                            .padding([.trailing, .leading], 10)
                    }
                    
                }
                .frame(minHeight: proxy.size.height)
            }
            .refreshable {
                print("Do your refresh work here")
            }
        }
    }
}
