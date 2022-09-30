//
//  CityAddViewController.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/28/22.
//

import UIKit
import SwiftUI
import DataManager
import MapKit

class CityAddViewController: UIViewController {
    
    public let viewModel = CityAddViewModel()
    @IBOutlet private weak var textField: UITextField?
    @IBOutlet private weak var tableView: UITableView?
    public var didAddCityHandler: ((SimpleCoord) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField?.delegate = self
        tableView?.dataSource = self
        tableView?.delegate = self
        setUpViewModel()
    }
    
    fileprivate func setUpViewModel() {
        
        viewModel.didAddCityHandler = {[weak self] simpleCoord in
            self?.dismiss(animated: true, completion: {
                self?.didAddCityHandler?(simpleCoord)
            })
        }
        
        viewModel.citiesFoundHandler = {[weak self] in
            self?.tableView?.reloadData()
        }

    }
}

extension CityAddViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let query = textField.text,
              !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {return true}
        
        viewModel.findPlaces(withQuery: query)
        return true
    }
}

extension CityAddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityAddCell", for: indexPath)
        cell.textLabel?.text = viewModel.cities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = viewModel.cities[indexPath.row]
        viewModel.getCoords(forCity: city)
    }
}
