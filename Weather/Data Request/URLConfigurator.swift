//
//  URLConfigurator.swift
//  Parse Data test
//
//  Created by media-pt on 28.10.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation

typealias UrlConfig = (urlString: String?, methodHttp: String)

struct URLConfigurator {
    
    static func configureUrl(dictionaryData: NSDictionary, dictHttpBody: NSDictionary?, methodName: MethodName) -> UrlConfig {
        
        switch methodName {
        case MethodName.getGroupById:
            
            let array = dictionaryData.value(forKey: "idArray") as! [String]
            var ar = ["689558", "703448"]
            ar.append(contentsOf: array)
            let stringC = ar.joined(separator: ",")
            
            let urlString = "\(API_URL)group?id=\(stringC)&units=metric&appid=\(APPID)"
            
            return (urlString, MethodHttp.get.rawValue)
            
        case MethodName.getPalceAutocomplete:
            
            let input = dictionaryData.value(forKey: "input") as! String
            
            let urlString = "\(AUTOCOMPLETE)input=\(input)&key=\(ApiKey)"
            
            return (urlString, MethodHttp.get.rawValue)
            
        case MethodName.getPalceByName:
            
            let city = dictionaryData.value(forKey: "city") as! String
            
            let urlString = "\(API_URL)weather?q=\(city)&units=metric&appid=\(APPID)"
            
            return (urlString, MethodHttp.get.rawValue)
            
        default:
            return (nil, MethodHttp.get.rawValue)
        }
    }
}
