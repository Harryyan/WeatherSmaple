//
//  MockAppService.swift
//  WeatherSmapleTests
//
//  Created by Harry Yan on 7/11/20.
//

import Foundation
@testable import WeatherSmaple

class WeatherService: NetworkServiceProtocol {
    
    func loadWeather(on request: WeatherRequest, completion: @escaping (Result<Weather?, Error>) -> Void) {
        let mockWeather: Weather = .init(id: 0,
                                         coordinates: Coordinate.init(lon: -10, lat: 100),
                                         name: "Auckland",
                                         weatherInfoList: [],
                                         main: MainInfo(temp: 0, pressure: 0, humidity: 0, temp_min: 0, temp_max: 0),
                                         wind: WindInfo(speed: 0, deg: 0),
                                         clouds: Cloud(all: 0),
                                         dateText: nil)
        completion(.success(mockWeather))
    }
    
    func loadForecastWeather(on request: ForecastWeatherRequest, completion: @escaping (Result<[Weather]?, Error>) -> Void) {
        
    }
}
