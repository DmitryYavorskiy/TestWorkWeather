//
//  CityGroup.swift
//  Weather
//
//  Created by Dmitriy Yavorskiy on 15.11.16.
//  Copyright © 2016 Dmitriy Yavorskiy. All rights reserved.
//

import Foundation
import RealmSwift

class CityGroup: Object {
    
    dynamic var name = ""
    dynamic var id = 0
    dynamic var icon = ""
    dynamic var temp = 0
    dynamic var humidity = 0
    dynamic var windSpeed = 0.0
    
}
