//
//  CityWaitingListController.swift
//  WeatherSmaple
//
//  Created by Harry Yan on 20/11/20.
//

import UIKit


protocol WaitlinglistProtocol: class {
    func didSelect(city: AddedCity)
}



class CityWaitingListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var cityList: [AddedCity] = []
    
    weak var delegate: WaitlinglistProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "City List"
        
        register()
        addSampleData()
        
        tableView.reloadData()
    }
    
    
    private func addSampleData() {
        let auckland = AddedCity(id: 1, name: "Auckland", lat: -36.848461, lon: 174.763336, isFavorite: false, weather: nil)
        let wellington = AddedCity(id: 2, name: "Wellington", lat: -41.286461, lon: 174.776230, isFavorite: false, weather: nil)
        let christchurch = AddedCity(id: 2, name: "Christchurch", lat: -43.532055, lon: 172.636230, isFavorite: false, weather: nil)
        let dunedin = AddedCity(id: 2, name: "Dunedin", lat: -45.878761, lon: 170.502792, isFavorite: false, weather: nil)
        let piha = AddedCity(id: 2, name: "Piha", lat: -36.954601, lon: 174.473999, isFavorite: false, weather: nil)
        
        cityList.append(auckland)
        cityList.append(wellington)
        cityList.append(christchurch)
        cityList.append(dunedin)
        cityList.append(piha)
    }
    
    private func register() {
        tableView.register(UINib(nibName: "SingleCityCell", bundle: nil), forCellReuseIdentifier: "SingleCityCell")
        tableView.tableFooterView = UIView()
    }
    
}


extension CityWaitingListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCityCell", for: indexPath) as! SingleCityCell
        cell.updateCity(by: cityList[indexPath.row].name)
        
        return cell
    }
}

extension CityWaitingListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let city = cityList[indexPath.row]
        
        delegate?.didSelect(city: city)
        
        dismiss(animated: true, completion: nil)
    }
}
