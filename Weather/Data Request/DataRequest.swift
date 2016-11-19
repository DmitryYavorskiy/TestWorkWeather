//
//  DataRequest.swift
//  Parse Data test
//
//  Created by media-pt on 07.10.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation
import UIKit

public enum MethodName: String {
    case getGroupById
    case getPalceAutocomplete
    case getPalceByName
    case getDaysWeather
    case glc
}

public enum MethodHttp: String {
    case get = "GET"
    case post = "POST"
}

public struct DataRequest {
    
    public static func getData(dictionaryData: NSDictionary, dictHttpBody: NSDictionary?, methodName: MethodName, completionHandler:((_ succes: Bool, _ info: NSDictionary, _ errorCode: Int) -> Void)!) {
        
        let internetStatus = InternetConnection.checkInternetConnection()
        
        if internetStatus == true {
            
            let configuration: UrlConfig = URLConfigurator.configureUrl(dictionaryData: dictionaryData, dictHttpBody: dictHttpBody, methodName: methodName)
            
            APIRequest.getRequest(urlString: configuration.urlString!, methodHttp: configuration.methodHttp, post: nil, completionHandler: { (succes, info) in
                
                if succes == true {
                    DataMask.parseData(dictionary: info, type: methodName, completionHandler: { (succes, info) in
                        completionHandler(true, info, 200)
                    })
                } else {
                    print("succes error")
                }
            })
        } else {
            print("internet Error")
        }
    }
}
