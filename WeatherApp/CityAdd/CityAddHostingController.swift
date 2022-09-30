//
//  CityAddHostingController.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/28/22.
//

import UIKit
import SwiftUI
import DataManager
import MapKit

class CityAddViewController: UIViewController {
    
    let viewModel = CityAddViewModel()
    fileprivate lazy var googlePlacesManager: GooglePlacesManagerProtocol = GooglePlacesManager.sharedInstance
    let svc = UISearchController(searchResultsController: SearchResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Find City", comment: "FIND_CITY")
        svc.searchResultsUpdater = self
        navigationItem.searchController = svc
    }
}

extension CityAddViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let rvc = searchController.searchResultsController as? SearchResultsViewController
        else {return}
        
        googlePlacesManager.findPlaces(query, completion: {result in
            switch result {
            case .success(let cities):
                print("cities::: \(cities)")
                DispatchQueue.main.async {
                    rvc.updateSearchResults(newCities: cities)
                }
            case .failure(let error):
                print("places error::: \(error.localizedDescription)")
            }
        })
    }
}

class CityAddHostingController: UIHostingController<HomeCityView> {}
