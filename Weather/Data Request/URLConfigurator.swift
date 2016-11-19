//
//  URLConfigurator.swift
//  Parse Data test
//
//  Created by media-pt on 28.10.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation

public typealias UrlConfig = (urlString: String?, methodHttp: String)

public struct URLConfigurator {
    
    public static func configureUrl(dictionaryData: NSDictionary, dictHttpBody: NSDictionary?, methodName: MethodName) -> UrlConfig {
        
        switch methodName {
        case MethodName.getGroupById:
            
            var array = dictionaryData.value(forKey: "idArray") as! [Int]
            var dynamicArr = [689558, 703448]
            
            if array.count > 2 {
                let needItem = array[2..<array.count]
                dynamicArr.append(contentsOf: needItem)
            }
            
            let stringArray = dynamicArr.map { String($0) }
            let stringCurrent = stringArray.joined(separator: ",")
            
            let urlString = "\(API_URL)group?id=\(stringCurrent)&units=\(TemperatyreType)&appid=\(APPID)"
            
            return (urlString, MethodHttp.get.rawValue)
            
        case MethodName.getPalceAutocomplete:
            
            let input = dictionaryData.value(forKey: "input") as! String
            
            let urlString = "\(AUTOCOMPLETE)input=\(input)&key=\(ApiKey)"
            
            return (urlString, MethodHttp.get.rawValue)
            
        case MethodName.getPalceByName:
            
            let city = dictionaryData.value(forKey: "city") as! String
            
            let urlString = "\(API_URL)weather?q=\(city)&units=metric&appid=\(APPID)"
            
            return (urlString, MethodHttp.get.rawValue)
            
        case MethodName.getDaysWeather:
            
            let id = dictionaryData.value(forKey: "id") as! Int
            
            let urlString = "\(API_URL)forecast/daily?id=\(id)&cnt=7&units=\(TemperatyreType)&appid=\(APPID)"
            
            return (urlString, MethodHttp.get.rawValue)
            
        default:
            return (nil, MethodHttp.get.rawValue)
        }
    }
}
