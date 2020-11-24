//
//  AppService.swift
//  FancyWeather
//
//  Created by Harry Yan on 5/07/19.
//  Copyright © 2019 Harry Yan. All rights reserved.
//

import GooglePlaces

protocol Service {
    static func start()
    static func loadWeather(of city: AddedCity, completion: @escaping (Weather?) -> Void)
    static func loadForecastWeather(of city: AddedCity, completion: @escaping ([Weather]?) -> Void)
}

struct AppService: Service {
    private static let weatherService = WeatherService()
    
    static func start() {
        registerGooglePlaceService()
        LocationService.default.start()
    }
    
    static func loadWeather(of city: AddedCity, completion: @escaping (Weather?) -> Void) {
        let req = WeatherRequest(lat: city.lat, lon: city.lon)
        weatherService.loadWeather(on: req) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    completion(weather)
                case .failure(_):
                    completion(nil)
                }
            }
        }
    }
    
    static func loadForecastWeather(of city: AddedCity, completion: @escaping ([Weather]?) -> Void) {
        let req = ForecastWeatherRequest(lat: city.lat, lon: city.lon)
        weatherService.loadForecastWeather(on: req) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weathers):
                    let indexSet = [0, 8, 16, 24, 32]
                    let selectedWeathersTuple = weathers?.enumerated().filter { (index, _) in
                        indexSet.contains(index)
                    }
                    
                    if let strongWeatherTuple = selectedWeathersTuple {
                        var forecastWeather: [Weather] = []
                        for (_, element) in strongWeatherTuple {
                            forecastWeather.append(element)
                        }
                        
                        completion(forecastWeather)
                    }
                case .failure(_):
                    completion(nil)
                }
            }
        }
    }
    
    static func registerGooglePlaceService() {
        GMSPlacesClient.provideAPIKey(Configuration.googlePlaceAPIKey)
    }
}
