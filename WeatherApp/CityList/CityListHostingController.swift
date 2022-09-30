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
        
        viewModel.didTapAddCityHandler = {[weak self] in
            self?.performSegue(withIdentifier: cityListControllerToCityAddController, sender: self)
        }
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

// MARK: - Navigation
extension CityListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == cityListControllerToCityAddController, let vc = segue.destination as? CityAddViewController {
            
            vc.viewModel.didAddCityHandler = {[weak self] simpleCoord in
                self?.viewModel.addCity(forCoordinates: simpleCoord)
            }
        }
    }
}

class CityListHostingController: UIHostingController<CityListView> {}
