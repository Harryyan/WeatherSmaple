//
//  CityWeatherICell.swift
//  WeatherSmaple
//
//  Created by Harry Yan on 7/11/20.
//

import UIKit
import SDWebImage

class CityWeatherICell: UITableViewCell {
    
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var main: UILabel!
    @IBOutlet weak var sub: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var star: UIButton!
    
    var favorited: Bool = false
    
    // MARK: - internal
    
    func updateInfo(of city: AddedCity) {
        weatherImg.sd_setImage(with: city.weather?.weatherInfoList.first?.iconURL)
        main.text = city.weather?.name
        sub.text = city.weather?.weatherInfoList.first?.description
        temp.text = String(format: "%ld°C~%ld°C", Int(city.weather?.main.minTemp ?? 0), Int(city.weather?.main.maxTemp ?? 0))
        
        favorited = city.isFavorite
        star.setImage(UIImage(systemName: favorited ? "star.fill" : "star"), for: .normal)
    }
    
    // MARK: - Action
    
    @IBAction func didTapStar(_ sender: Any) {
        favorited = !favorited
        
        star.setImage(UIImage(systemName: favorited ? "star.fill" : "star"), for: .normal)
    }
}
