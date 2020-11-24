//
//  CityInfo.swift
//  FancyWeather
//
//  Created by Harry Yan on 6/07/19.
//  Copyright © 2019 Harry Yan. All rights reserved.
//

import SwiftUI

struct AddedCity: Codable, Identifiable {
    var id: Int = 0
    var name: String
    var lat: Double
    var lon: Double
    var isFavorite: Bool
    var weather: Weather?
}
