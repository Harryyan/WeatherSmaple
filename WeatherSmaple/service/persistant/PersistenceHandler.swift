//
//  PersistenceHandler.swift
//  WeatherSample
//
//  Created by Harry Yan on 6/07/19.
//  Copyright © 2019 Harry Yan. All rights reserved.
//

import CoreData
import UIKit

struct PersistenceHandler {
    private static let dbName = "City"
    
    private static let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private static let managedContext: NSManagedObjectContext? = appDelegate?.persistentContainer.viewContext
    
    static func add(_ selectedCity: AddedCity) {
        if let context = managedContext, let entity = NSEntityDescription.entity(forEntityName: dbName, in: context) {
            let city = NSManagedObject(entity: entity, insertInto: managedContext)
            
            city.setValue(selectedCity.name, forKeyPath: "name")
            city.setValue(selectedCity.lat, forKeyPath: "lat")
            city.setValue(selectedCity.lon, forKeyPath: "lon")
            city.setValue(selectedCity.isFavorite, forKeyPath: "isFavorite")
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func delete(_ addedCity: AddedCity) {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lat==\(addedCity.lat)&&lon==\(addedCity.lon)")
        
        do {
            let results = try managedContext?.fetch(fetchRequest)
            guard let finalResults = results, finalResults.count > 0 else { return }
            
            for object in finalResults {
                managedContext?.delete(object)
            }
            
            do {
                try managedContext?.save()
            } catch {
                fatalError();
            }
        } catch {
            fatalError()
        }
    }
    
    static func update(_ selectedCity: AddedCity) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: dbName)
        fetchRequest.predicate = NSPredicate(format: "lat==\(selectedCity.lat)&&lon==\(selectedCity.lon)")
        
        do {
            let results = try managedContext?.fetch(fetchRequest)
            if let city = results?.first {
                city.setValue(selectedCity.name, forKeyPath: "name")
                city.setValue(selectedCity.lat, forKeyPath: "lat")
                city.setValue(selectedCity.lon, forKeyPath: "lon")
                city.setValue(selectedCity.isFavorite, forKeyPath: "isFavorite")
                
                do {
                    try managedContext?.save()
                } catch {
                    print(error)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    static func allSync() -> [AddedCity] {
        var cityList: [AddedCity] = []
        var rawData: [NSManagedObject]? = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: dbName)
        
        do {
            rawData = try managedContext?.fetch(fetchRequest)
            guard let data = rawData else { return [] }
            
            _ = data.compactMap {
                let name = $0.value(forKeyPath: "name") as? String
                let latitude = $0.value(forKeyPath: "lat") as? Double
                let longitude = $0.value(forKeyPath: "lon") as? Double
                let isFavorite = $0.value(forKeyPath: "isFavorite") as? Bool
                
                let city = AddedCity(name: name ?? "Auckland",
                                     lat: latitude ?? 0.0,
                                     lon: longitude ?? 0.0,
                                     isFavorite: isFavorite ?? false)
                cityList.append(city)
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return cityList
    }
    
    static func all(completion: @escaping ([AddedCity]) -> Void) {
        var cityList: [AddedCity] = []
        var rawData: [NSManagedObject]? = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: dbName)
        
        do {
            rawData = try managedContext?.fetch(fetchRequest)
            guard let data = rawData else { return }
            
            _ = data.compactMap {
                let name = $0.value(forKeyPath: "name") as? String
                let latitude = $0.value(forKeyPath: "lat") as? Double
                let longitude = $0.value(forKeyPath: "lon") as? Double
                let isFavorite = $0.value(forKeyPath: "isFavorite") as? Bool
                
                let city = AddedCity(name: name ?? "Auckland",
                                     lat: latitude ?? 0.0,
                                     lon: longitude ?? 0.0,
                                     isFavorite: isFavorite ?? false)
                cityList.append(city)
            }
            
            DispatchQueue.main.async {
                completion(cityList)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    static func exist(of city: AddedCity) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: dbName)
        fetchRequest.predicate = NSPredicate(format: "lat==\(city.lat)&&lon==\(city.lon)")
        
        do {
            let results = try managedContext?.fetch(fetchRequest)
            if let strongResult = results, strongResult.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
