//
//  DataMask.swift
//  Parse Data test
//
//  Created by media-pt on 07.10.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation
import RealmSwift

public struct DataMask {
    
    public static func parseData(dictionary: NSDictionary, type: MethodName, completionHandler:((_ succes: Bool, _ info: NSDictionary) -> Void)!)  {
        
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
            
            let filterId = realm.objects(CityGroup.self).filter("id == \(idCity)")
            
            
            let nameCity = dictionary.value(forKey: "name") as! String
            let iconCity = dictionary.value(forKeyPath: "weather.icon") as! NSArray
            let tempCity = dictionary.value(forKeyPath: "main.temp") as! Double
            let humidityCity = dictionary.value(forKeyPath: "main.humidity") as! Int
            let windSpeedCity = dictionary.value(forKeyPath: "wind.speed") as! Double
            
            if filterId.count == 0 {
                let cityGroup = CityGroup()
                cityGroup.id = idCity
                cityGroup.name = nameCity
                cityGroup.icon = iconCity[0] as! String
                cityGroup.temp = Int(tempCity)
                cityGroup.humidity = humidityCity
                cityGroup.windSpeed = windSpeedCity
                
                try! realm.write {
                    realm.add(cityGroup)
                    print("Added \(cityGroup.name) to Realm City")
                }
            }
            
            completionHandler(true, ["" : ""])
            
        case MethodName.getDaysWeather:
            
            let realm = try! Realm()
            
            let idCity = dictionary.value(forKeyPath: "city.id") as! Int
            
            let group = realm.objects(CityWeather.self).filter("id == \(idCity)")
            
            if group.count > 0 {
                realm.beginWrite()
                realm.delete(group)
                try! realm.commitWrite()
                
                addDayWeather(dict: dictionary)
            } else {
                addDayWeather(dict: dictionary)
            }
            
            completionHandler(true, ["" : ""])
            
        default:
            print("error")
        }
    }
    
    private static func addDayWeather(dict: NSDictionary) {
        
        let idCity = dict.value(forKeyPath: "city.id") as! Int
        let nameCity = dict.value(forKeyPath: "city.name") as! String
        
        let cnt = dict.value(forKey: "cnt") as! Int
        
        let dt = dict.value(forKeyPath: "list.dt") as! NSArray
        let dayTemp = dict.value(forKeyPath: "list.temp.day") as! NSArray
        let minTemp = dict.value(forKeyPath: "list.temp.min") as! NSArray
        let maxTemp = dict.value(forKeyPath: "list.temp.max") as! NSArray
        let nightTemp = dict.value(forKeyPath: "list.temp.night") as! NSArray
        let eveTemp = dict.value(forKeyPath: "list.temp.eve") as! NSArray
        let mornTemp = dict.value(forKeyPath: "list.temp.morn") as! NSArray
        let pressure = dict.value(forKeyPath: "list.pressure") as! NSArray
        let humidity = dict.value(forKeyPath: "list.humidity") as! NSArray
        let icon = dict.value(forKeyPath: "list.weather.icon") as! NSArray
        let speedWind = dict.value(forKeyPath: "list.speed") as! NSArray
        
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm";
        let currentDate = formatter.string(from: date)
        
        let realm = try! Realm()
        
        let cityWeather = CityWeather()
        
        cityWeather.id = idCity
        cityWeather.name = nameCity
        cityWeather.date = currentDate
        
        var weather = Weather()
        
        for i in 0..<cnt {
            
            let currIcon = icon[i] as! NSArray
            let dayWeek = CurrentDayWeek.getDayOfWeek(dt[i] as! Int)
            
            weather = Weather()
            weather.dt = dayWeek != nil ? dayWeek! : ""
            weather.dayTemp = Int(dayTemp[i] as! Double)
            weather.minTemp = Int(minTemp[i] as! Double)
            weather.maxTemp = Int(maxTemp[i] as! Double)
            weather.nightTemp = Int(nightTemp[i] as! Double)
            weather.eveTemp = Int(eveTemp[i] as! Double)
            weather.mornTemp = Int(mornTemp[i] as! Double)
            weather.pressure = pressure[i] as! Double
            weather.humidity = humidity[i] as! Int
            weather.icon = currIcon[0] as! String
            weather.speedWind = speedWind[i] as! Double
            cityWeather.list.append(weather)
        }
        
        try! realm.write {
            realm.add(cityWeather)
            print("Added \(cityWeather.name) to Realm City")
        }
    }
}
