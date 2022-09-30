//
//  HomeCityHostingController.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import UIKit
import SwiftUI
import DataManager

class HomeCityViewController: UIViewController {
    let viewModel = HomeCityViewModel()
    fileprivate lazy var dataManager: DataManagerProtocol = DataManager.sharedInstance
    var city: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            self.city = await fetchCity()
        }
    }
    
    func fetchCity() async -> City? {
        let result: CityNetworkResult = await dataManager.fetchCurrentSummary(withName: "Miami", withCoordinates: nil)
        return City.deserializeCity(withNetworkResult: result)
    }
    
    @IBSegueAction func HomeCityViewControllerToHomeCityView(_ coder: NSCoder) -> UIViewController? {
        
        let homeCityView = HomeCityView(viewModel: viewModel)
        
        guard let vc = HomeCityHostingController(coder: coder, rootView: homeCityView) else {
            return UIViewController()
        }
        
        return vc
    }
}

class HomeCityHostingController: UIHostingController<HomeCityView> {}
