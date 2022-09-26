//
//  CityListHostingController.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/26/22.
//

import UIKit
import SwiftUI

class CityListHostingController: UIHostingController<CityListView> {
}

//class CityListViewController: UIViewController {
//    
//    @IBSegueAction func HomeCityViewControllerToHomeCityView(_ coder: NSCoder) -> UIViewController? {
//        
//        let viewModel = CityListViewModel()
//        let cityListView = CityListView(viewModel: viewModel)
//        
//        guard let vc = CityListHostingController(coder: coder, rootView: cityListView) else {
//            return UIViewController()
//        }
//        
//        return vc
//    }
//}
