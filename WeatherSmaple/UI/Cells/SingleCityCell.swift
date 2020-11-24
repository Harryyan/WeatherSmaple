//
//  SingleCityCell.swift
//  WeatherSmaple
//
//  Created by Harry Yan on 22/11/20.
//

import UIKit

class SingleCityCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCity(by name: String) {
        cityName.text = name
    }
    
}
