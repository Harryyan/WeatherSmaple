//
//  WeatherRequest.swift
//  FancyWeather
//
//  Created by Harry Yan on 6/07/19.
//  Copyright © 2019 Harry Yan. All rights reserved.
//

import Foundation

protocol Requestable {
    var path: String { get }
    var lat: Double { get set }
    var lon: Double { get set }
}


struct WeatherRequest: Requestable {
    var lat: Double
    var lon: Double
    
    var path: String {
        return "weather"
    }
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

struct ForecastWeatherRequest: Requestable {
    var lat: Double
    var lon: Double
    
    var path: String {
        return "forecast"
    }
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}
