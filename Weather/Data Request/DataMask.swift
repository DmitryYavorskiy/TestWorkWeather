//
//  DataMask.swift
//  Parse Data test
//
//  Created by media-pt on 07.10.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation
import RealmSwift

struct DataMask {
    
    static func parseData(dictionary: NSDictionary, type: MethodName, completionHandler:((_ succes: Bool, _ info: NSDictionary) -> Void)!)  {
        
        switch type {
        case MethodName.getGroupById:
            
            let realm = try! Realm()
            
            let count = dictionary.value(forKey: "cnt") as! Int
            
            let cityNameArray = dictionary.value(forKeyPath: "list.name") as! NSArray
            let cityIdArray = dictionary.value(forKeyPath: "list.id") as! NSArray
            let cityIconArray = dictionary.value(forKeyPath: "list.weather.icon") as! NSArray
            let cityTempArray = dictionary.value(forKeyPath: "list.main.temp") as! NSArray
            let cityHumidityArray = dictionary.value(forKeyPath: "list.main.humidity") as! NSArray
            let cityWindArray = dictionary.value(forKeyPath: "list.wind.speed") as! NSArray
            
            let group = realm.objects(CityGroup.self)
            realm.beginWrite()
            realm.delete(group)
            try! realm.commitWrite()
            
            for index in 0..<count {
                
                let cityName = cityNameArray[index] as! String
                let cityId = cityIdArray[index] as! Int
                let itemIcon = cityIconArray[index] as! NSArray
                let cityTemp = cityTempArray[index] as! Double
                let cityHumidity = cityHumidityArray[index] as! Int
                let cityWindSpeed = cityWindArray[index] as! Double
                
                let cityGroup = CityGroup()
                cityGroup.name = cityName
                cityGroup.id = cityId
                cityGroup.icon = itemIcon[0] as! String
                cityGroup.temp = Int(cityTemp)
                cityGroup.humidity = cityHumidity
                cityGroup.windSpeed = cityWindSpeed
                
                try! realm.write {
                    realm.add(cityGroup)
                    print("Added \(cityGroup.name) to Realm CityGroup")
                }
            }
            
            completionHandler(true, ["" : ""])
            
        case MethodName.getPalceAutocomplete:
            
            let cityName = dictionary.value(forKeyPath: "predictions.structured_formatting.main_text") as! NSArray
            
            completionHandler(true, ["cityName" : cityName])
            
        case MethodName.getPalceByName:
            
            let realm = try! Realm()
            
            let idCity = dictionary.value(forKey: "id") as! Int
            let nameCity = dictionary.value(forKey: "name") as! String
            
            let city = City()
            city.id = "\(idCity)"
            city.name = nameCity
            
            try! realm.write {
                realm.add(city)
                print("Added \(city.name) to Realm City")
            }
            
            completionHandler(true, ["" : ""])
            
        default:
            print("error")
        }
    }
}
