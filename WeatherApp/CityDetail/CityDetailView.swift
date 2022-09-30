//
//  CityDetailView.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import UIKit
import SwiftUI

struct CityDetailView: View {
    @ObservedObject var viewModel: CityDetailViewModel
    
    var body: some View {
        
        GeometryReader { proxy in
            if viewModel.isRefreshing {
                ProgressView()
                    .foregroundColor(Color(red: 51.0/255.0, green: 51.0/255.0, blue: 255.0/255.0))
                    .frame(width: UIScreen.main.bounds.size.width, height: 300, alignment: .center)
                
            } else {
                ScrollView {
                    VStack {
                        if viewModel.showCityList {
                            Button {
                                viewModel.didTapCityListHandler?()
                                
                            } label: {
                                Image(systemName: "list.bullet")
                                    .font(.system(size: 28, weight: .bold))
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(Color(red: 51.0/255.0, green: 51.0/255.0, blue: 255.0/255.0))
                            .padding([.trailing, .leading,], 10)
                            .padding([.bottom,], 5)
                        }
                        
                        Text(viewModel.city?.name ?? "")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom("SanFranciscoRounded-Bold", size: 37))
                            .foregroundColor(Color(red: 51.0/255.0, green: 51.0/255.0, blue: 255.0/255.0))
                            .padding([.trailing, .leading], 10)
                        
                        Spacer()
                        let computedTempText: String? = {
                            if let temp = viewModel.city?.temp?.fahrenheit, let feels = viewModel.city?.feelsLike?.fahrenheit {
                                return "It's \(Int(temp))º, but it feels like \(Int(feels))º"
                            } else if let temp = viewModel.city?.temp?.fahrenheit {
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
                        
                        //TODO: Add 5-day by 3 hour forcast horizontal scroll view
                        
                        if let desc = viewModel.city?.description {
                            Text("Summary: \(desc)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.custom("SanFranciscoRounded-Bold", size: 27))
                                .foregroundColor(Color(red: 102.0/255.0, green: 102.0/255.0, blue: 255.0/255.0))
                                .padding([.trailing, .leading], 10)
                        }
                        
                    }
                    .frame(minHeight: proxy.size.height)
                }
                .refreshable {
                    viewModel.didPullToRefreshHandler?()
                }
            }
            
        }
    }
}
