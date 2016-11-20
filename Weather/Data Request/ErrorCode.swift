//
//  ErrorCode.swift
//  Weather
//
//  Created by Dmitriy Yavorskiy on 20.11.16.
//  Copyright © 2016 Dmitriy Yavorskiy. All rights reserved.
//

import Foundation

struct ErrorCode {
    
    public static func error(statusCode: Int) -> String {
        
        switch statusCode {
        case 400:
            return "Error in query parameters"
        case 404:
            return "Resource not found"
        case 500:
            return "Internal Server Error"
        case 503:
            return "Service is temporarily unavailable"
        case 511:
            return "Error connecting to the Internet"
        default:
            return "Error data"
        }
    }
}
