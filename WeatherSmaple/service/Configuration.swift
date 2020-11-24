//
//  Configuration.swift
//  FancyWeather
//
//  Created by Harry Yan on 4/07/19.
//  Copyright © 2019 Harry Yan. All rights reserved.
//

import Foundation

struct Configuration {
    private static let endPointKey = "API_BASE_URL_ENDPOINT"
    
    // can't put sensitive info in build setting. info.plist or files,
    // will be exposed in App Bundle.
    static let apiKey = "749624da73649cb7d7d1f86a5d2e9a0b"
    static let googlePlaceAPIKey = "AIzaSyAZ_D7rwZJ-7p_9lpPoYGVueuoIABloOzc"
    static let cityPlaceholderIconURL = URL(string: "https://openweathermap.org/img/w/02d.png")!
    
    #if DEBUG
    enum Environment: String {
        case debugging = "https://api.openweathermap.org/data/2.5/"
        case staging = "https://staging_api.openweathermap.org/data/2.5/"  // not work, just for demo.
    }
    static let environment = Environment.debugging.rawValue
    #else
    static let environment = Bundle.main.infoDictionary?[Configuration.endPointKey] as? String ?? ""
    #endif
}
