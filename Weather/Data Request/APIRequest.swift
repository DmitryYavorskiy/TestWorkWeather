//
//  APIRequest.swift
//  Parse Data test
//
//  Created by media-pt on 07.10.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation
import UIKit

struct APIRequest {
    
    static func getRequest(urlString: String, methodHttp: String, post: String?, completionHandler:((_ succes: Bool, _ info: NSDictionary) -> Void)!) {
        
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        let url = NSURL(string: encodedString!)
        let request = NSMutableURLRequest(url:url as! URL)
        request.httpMethod = methodHttp
        
        if methodHttp == "POST" {
            let postData = post?.data(using: String.Encoding.utf8, allowLossyConversion: true)
            request.httpBody = postData
        }
        
        request.setValue("WEATHER/\(APP_Ver!) IOS/\(IOS_VER)", forHTTPHeaderField: "User-agent")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if let data = data {
                
                do {
                    
                    let requestData = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    
                    completionHandler(true, requestData)
                    
                } catch {
                    
                    print(error)
                    let requestData = NSDictionary()
                    completionHandler(false, requestData)
                    
                }
            } else {
                let requestData = NSDictionary()
                completionHandler(false, requestData)
            }
        })
        
        task.resume()
    }
}
