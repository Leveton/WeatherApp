//
//  CityForcastHostingController.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import UIKit
import SwiftUI

class CityForcastHostingController: UIHostingController<CityForcastView> {
}

class CityForcastViewController: UIViewController {
    let viewModel = CityForcastViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
