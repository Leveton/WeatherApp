//
//  CitySearchViewController.swift
//  WeatherApp
//
//  Created by Michael Leveton on 9/28/22.
//

import UIKit

class CitySearchViewController: UIViewController {
    fileprivate var cities = [City]()
    fileprivate lazy var googlePlacesManager: GooglePlacesManagerProtocol = GooglePlacesManager.sharedInstance
    public var didAddCityHandler: ((SimpleCoord) -> Void)?
    
    fileprivate let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.backgroundColor = .gray
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func updateSearchResults(newCities: [City]) {
        self.cities = newCities
        tableView.reloadData()
    }
}

extension CitySearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = cities[indexPath.row]
        
        googlePlacesManager.getCoordinatesForCity(city, completion: {[weak self] result in
            switch result {
            case .success(let coord):
                let simpleCoords: SimpleCoord = (lat: coord.latitude, long: coord.longitude)
                
                //Notify the City add controller that a new city was tapped
                self?.didAddCityHandler?(simpleCoords)
                
            case .failure(let error):
                //TODO: surface error
                print("get coord error::: \(error)")
            }
        })
    }
}
