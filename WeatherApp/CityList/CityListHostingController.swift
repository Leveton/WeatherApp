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
    fileprivate var chosenCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
        setUpViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCities()
    }
    
    @IBSegueAction func CityListControllerToCityView(_ coder: NSCoder) -> UIViewController? {
        let cityListView = CityListView(viewModel: viewModel)
        return CityListHostingController(coder: coder, rootView: cityListView)
    }
    
    private func setUpViewModel() {
        viewModel.didTapAddCityHandler = {[weak self] in
            self?.performSegue(withIdentifier: cityListControllerToCityAddController, sender: self)
        }
        
        viewModel.didTapCityDetailHandler = {[weak self] city in
            self?.chosenCity = city
            self?.performSegue(withIdentifier: cityListControllerToCityDetailController, sender: self)
        }
        
        viewModel.didPullToRefreshHandler = {[weak self] in
            self?.viewModel.fetchCities()
        }
    }
    
    @objc private func didTapBackButton() {
        performSegue(withIdentifier: unwindCityListController, sender: self)
    }
}

// MARK: - Navigation
extension CityListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == cityListControllerToCityAddController, let vc = segue.destination as? CityAddViewController {
            
            vc.didAddCityHandler = {[weak self] simpleCoord in
                self?.viewModel.addCity(forCoordinates: simpleCoord)
            }
        }
        if segue.identifier == cityListControllerToCityDetailController, let vc = segue.destination as? CityDetailViewController {
            vc.viewModel.showCityList = false
            if let chosenCity = chosenCity {
                vc.viewModel.city = chosenCity
            }
        }
    }
}

class CityListHostingController: UIHostingController<CityListView> {}
