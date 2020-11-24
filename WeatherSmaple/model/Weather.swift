//
//  Weather.swift
//  FancyWeather
//
//  Created by Harry Yan on 6/07/19.
//  Copyright © 2019 Harry Yan. All rights reserved.
//

import Foundation
import SwiftUI

extension Array where Element: Equatable {
    func all(where predicate: (Element) -> Bool) -> [Element]  {
        return self.compactMap { predicate($0) ? $0 : nil }
    }
}

struct ForecastWeatherWrapper: Codable {
    var list: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

struct Weather: Codable, Identifiable {
    var id: Int?
    var coordinates: Coordinate?
    var name: String?
    var weatherInfoList: [WeatherInfo]
    var main: MainInfo
    var wind: WindInfo
    var clouds: Cloud
    var dateText: String?
    var dateForDisplay: String {
        return String(dateText?.split(separator: " ").first ?? "-- --")
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case coordinates = "coord"
        case name = "name"
        case weatherInfoList = "weather"
        case main = "main"
        case wind = "wind"
        case clouds = "clouds"
        case dateText = "dt_txt"
    }
}

extension Weather: Equatable {
    static func ==(lhs: Weather, rhs: Weather) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Coordinate: Codable {
    var lon: Double
    var lat: Double
}

struct WeatherInfo: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
    var iconURL: URL {
        return URL(string: "https://openweathermap.org/img/w/\(icon).png") ?? Configuration.cityPlaceholderIconURL
    }
}

struct MainInfo: Codable {
    var temp: Double
    var pressure: Double
    var humidity: Int
    var temp_min: Double
    var temp_max: Double
    
    var minTemp: Double {
        return temp_min - 273.15
    }
    
    var maxTemp: Double {
        return temp_max - 273.15
    }
    
    var temp_c: Double {
        return temp - 273.15
    }
}

struct WindInfo: Codable {
    var speed: Double
    var deg: Double
    
    var direction: String {
        let directions = ["North", "NorthEastern", "East", "SouthEastern", "Southern", "SouthWestern", "West", "NorthWestern"]
        let i: Int = Int((deg + 33.75)/45)
        return directions[i % 8]
    }
}

struct Cloud: Codable {
    var all: Double
}
