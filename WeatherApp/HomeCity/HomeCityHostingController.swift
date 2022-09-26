//
//  HomeCityHostingController.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import UIKit
import SwiftUI

class HomeCityHostingController: UIHostingController<HomeCityView> {
}

class HomeCityViewController: UIViewController {
    
    @IBSegueAction func HomeCityViewControllerToHomeCityView(_ coder: NSCoder) -> UIViewController? {
        
        let viewModel = HomeCityViewModel()
        let homeCityView = HomeCityView(viewModel: viewModel)
        
        guard let vc = HomeCityHostingController(coder: coder, rootView: homeCityView) else {
            return UIViewController()
        }
        
        return vc
    }
}
