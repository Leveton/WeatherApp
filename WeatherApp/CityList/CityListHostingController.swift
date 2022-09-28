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

class CityListViewController: UIViewController {
    let viewModel = CityListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
