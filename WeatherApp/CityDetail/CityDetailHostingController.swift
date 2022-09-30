//
//  CityDetailHostingController.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/25/22.
//

import UIKit
import SwiftUI

class CityDetailViewController: UIViewController {
    public var viewModel: CityDetailViewModel? {
        didSet {
            viewModel?.didTapCityListHandler = {[weak self] in
                self?.performSegue(withIdentifier: cityDetailControllerToCityListController, sender: self)
            }
        }
    }
    
    public var homeCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await refreshCity()
        }
    }
    
    private func refreshCity() async {
        guard let vm = viewModel, let city = homeCity else {return}
        
        //Default to coordinates because it's much less error prone than name
        if let coord = city.coord {
            let simpleCoord = (lat: coord.latitude, long: coord.longitude)
            await vm.fetchSummaryWithCoordinates(simpleCoord)
        } else {
            await vm.fetchSummaryWithName(city.name)
        }
    }
    
    @IBSegueAction func CityDetailViewControllerToCityDetailView(_ coder: NSCoder) -> UIViewController? {
        //TODO: ask for location services to get current city
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
            homeCity = city
            return city
        }()
        
        let vm = CityDetailViewModel(currentCity)
        viewModel = vm
        let cityDetailView = CityDetailView(viewModel: vm)
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
