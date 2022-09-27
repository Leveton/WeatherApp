//
//  HomeCityHostingController.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import UIKit
import SwiftUI
import DataManager

class HomeCityHostingController: UIHostingController<HomeCityView> {
}

class HomeCityViewController: UIViewController {
    fileprivate lazy var dataManager: DataManagerProtocol = DataManager.sharedInstance
    var city: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            self.city = await fetchCity()
            
        }
    }
    
    func fetchCity() async -> City? {
        let result: Result<Data?, APIManagerError> = await dataManager.fetchCurrentSummary(withName: "foo", withCoordinates: nil)
        switch result {
        
        case .success(let data):
            guard let data = data else {return nil}
            do {
                let city: City? = try JSONDecoder().decode(City.self, from: data)
                return city
            } catch {
                print("Decoding error::: \(error.localizedDescription)")
                return nil
            }
            
        case .failure(let error):
            print("API error::: \(error.localizedDescription)")
            return nil
        }
    }
    
    @IBSegueAction func HomeCityViewControllerToHomeCityView(_ coder: NSCoder) -> UIViewController? {
        
        let viewModel = HomeCityViewModel()
        let homeCityView = HomeCityView(viewModel: viewModel)
        
        guard let vc = HomeCityHostingController(coder: coder, rootView: homeCityView) else {
            return UIViewController()
        }
        
        return vc
    }
}
