//
//  LocationService.swift
//  FancyWeather
//
//  Created by Harry Yan on 6/07/19.
//  Copyright © 2019 Harry Yan. All rights reserved.
//

import CoreLocation

final class LocationService: NSObject {
    static let `default` = LocationService()
    
    private var alreadyCalledLocationUpdate = false
    private var locationManager: CLLocationManager
    
    private lazy var cityList: [AddedCity] = {
        return PersistenceHandler.allSync()
    }()
    
    private init(_ manager: CLLocationManager = CLLocationManager()) {
        locationManager = manager
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        super.init()
        
        locationManager.delegate = self
    }
    
    func start() {
        let currentStatus = CLLocationManager().authorizationStatus
        
        switch currentStatus {
        case .notDetermined:
            Self.default.locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("deny!") // pop up warning window
        default: break
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // avoid multiple calls
        guard alreadyCalledLocationUpdate == false else { return }
        
        alreadyCalledLocationUpdate = true
        
        if let lat = locations.first?.coordinate.latitude,
           let lon = locations.first?.coordinate.longitude,
           cityList.filter({$0.lat == lat && $0.lon == lon}).count == 0 {
            let rountLat = Double(round(100*lat)/100)
            let rountLon = Double(round(100*lon)/100)
            let currentNewCity = AddedCity(name: "", lat: rountLat, lon: rountLon, isFavorite: false)
            
            PersistenceHandler.add(currentNewCity)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        alreadyCalledLocationUpdate = false
        locationManager.stopUpdatingHeading()
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            guard PersistenceHandler.allSync().count == 0 else { break }
            locationManager.requestLocation()
        default: return
        }
    }
}
