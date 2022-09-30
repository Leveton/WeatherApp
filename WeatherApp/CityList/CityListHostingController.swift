//
//  CityListHostingController.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/26/22.
//

import UIKit
import SwiftUI

class CityListViewController: UIViewController {
    public let viewModel = CityListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCities()
    }
    
    @IBSegueAction func CityListControllerToCityView(_ coder: NSCoder) -> UIViewController? {
        let cityListView = CityListView(viewModel: viewModel)
        guard let vc = CityListHostingController(coder: coder, rootView: cityListView) else {
            return UIViewController()
        }
        
        return vc
    }
    
}

class CityListHostingController: UIHostingController<CityListView> {}
