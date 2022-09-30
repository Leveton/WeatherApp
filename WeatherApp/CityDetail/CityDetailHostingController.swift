//
//  CityDetailHostingController.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import UIKit
import SwiftUI

class CityDetailViewController: UIViewController {
    public var viewModel = CityDetailViewModel()
    
    public var homeCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            viewModel.isRefreshing = true
            await refreshCity()
            
            withAnimation {
                viewModel.isRefreshing = false
            }
        }
    }
    
    private func setUpViewModel() {
        viewModel.didTapCityListHandler = {[weak self] in
            self?.performSegue(withIdentifier: cityDetailControllerToCityListController, sender: self)
        }
        
        viewModel.didPullToRefreshHandler = {[weak self] in
            Task {
                await self?.refreshCity()
            }
        }
    }
    
    private func refreshCity() async {
        //TODO: ask for location services to get current city at app launch
        let currentCity: City = {
            if let homeCity = homeCity {
                return homeCity
            }
            
            var city = City(name: "Manhattan",
                        lat: 40.7647242,
                        lon: -73.9844751)
            city.temp = 299.9
            city.feelsLike = 279.9
            city.description = "Slightly windy with a chance of showers"
            return city
        }()
        
        
        await viewModel.fetchSummaryWithName(currentCity.name)
        
        homeCity = viewModel.city
    }
    
    @IBSegueAction func CityDetailViewControllerToCityDetailView(_ coder: NSCoder) -> UIViewController? {
        
        let cityDetailView = CityDetailView(viewModel: viewModel)
        return  CityDetailHostingController(coder: coder, rootView: cityDetailView)
    }
    
}

// MARK: - Navigation
extension CityDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == cityDetailControllerToCityListController, let vc = segue.destination as? CityListViewController {
            vc.viewModel.homeCity = homeCity
        }
    }
}

class CityDetailHostingController: UIHostingController<CityDetailView> {}
