//
//  WeatherListViewController.swift
//  WeatherSmaple
//
//  Created by Harry Yan on 7/11/20.
//

import UIKit
import GooglePlaces

class WeatherListViewController: UIViewController {
    
    @IBOutlet weak var cities: UITableView!
    
    private var cityList: [AddedCity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cities"
        
        register()
        loadWeather()
        
        reloadWeather()
    }
    
    
    // MARK: - Private
    
    private func register() {
        cities.register(UINib(nibName: "CityWeatherICell", bundle: nil), forCellReuseIdentifier: "CityWeatherICell")
        cities.tableFooterView = UIView()
    }
    
    private func loadWeather() {
        for (index, city) in cityList.enumerated() {
            AppService.loadWeather(of: city) { result in
                self.cityList[index].id = result?.id ?? 0
                self.cityList[index].weather = result
                self.cityList[index].name = result?.name ?? "None"
                
                if PersistenceHandler.exist(of: city) {
                    PersistenceHandler.update(self.cityList[index])
                } else {
                    PersistenceHandler.add(city)
                }
                
                self.cities.reloadData()
            }
        }
    }
    
    private func reloadWeather() {
        PersistenceHandler.all { [self]  result in
            cityList = result
            
            if cityList.count > 0 {
                loadWeather()
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func didTapAdd(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let cityListViewController = storyboard.instantiateViewController(withIdentifier: "cityWaitingListViewController") as? CityWaitingListController else { return }
        
        cityListViewController.delegate = self
        
        let nav = UINavigationController(rootViewController: cityListViewController)
        present(nav, animated: true, completion: nil)
    }
}

extension WeatherListViewController: WaitlinglistProtocol {
    
    func didSelect(city: AddedCity) {
        guard !PersistenceHandler.exist(of: city) else { return }
        
        PersistenceHandler.add(city)
        
        reloadWeather()
    }
}


extension WeatherListViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityWeatherICell", for: indexPath) as! CityWeatherICell
        cell.updateInfo(of: cityList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
