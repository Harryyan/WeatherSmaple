//
//  WeatherService.swift
//  FancyWeather
//
//  Created by Harry Yan on 6/07/19.
//  Copyright © 2019 Harry Yan. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol: class {
    func loadWeather(on request: WeatherRequest, completion: @escaping (Result<Weather?, Error>) -> Void)
    func loadForecastWeather(on request: ForecastWeatherRequest, completion: @escaping (Result<[Weather]?, Error>) -> Void)
}

final class WeatherService: NetworkServiceProtocol  {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func loadWeather(on request: WeatherRequest, completion: @escaping (Result<Weather?, Error>) -> Void) {
        let host = Configuration.environment
        let path = request.path
        
        guard var urlComponents = URLComponents(string: host + path) else { preconditionFailure("Can't create url components...") }
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(request.lat)),
            URLQueryItem(name: "lon", value: String(request.lon)),
            URLQueryItem(name: "appid", value: Configuration.apiKey)
        ]
        guard let url = urlComponents.url else { preconditionFailure("Can't create url from url components...") }
        
        session.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    let data = data ?? Data()
                    let response = try self?.decoder.decode(Weather.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // Todo: loadForecastWeather and loadWeather can be refactor by generic type, such a duplication!
    func loadForecastWeather(on request: ForecastWeatherRequest, completion: @escaping (Result<[Weather]?, Error>) -> Void) {
        let host = Configuration.environment
        let path = request.path
        
        guard var urlComponents = URLComponents(string: host + path) else { preconditionFailure("Can't create url components...") }
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(request.lat)),
            URLQueryItem(name: "lon", value: String(request.lon)),
            URLQueryItem(name: "appid", value: Configuration.apiKey)
        ]
        guard let url = urlComponents.url else { preconditionFailure("Can't create url from url components...") }
        
        session.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    let data = data ?? Data()
                    let result = try self?.decoder.decode(ForecastWeatherWrapper.self, from: data)
                    completion(.success(result?.list))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
        
    }
}
