//
//  CityWeather.swift
//  Weather
//
//  Created by Dmitriy Yavorskiy on 17.11.16.
//  Copyright © 2016 Dmitriy Yavorskiy. All rights reserved.
//

import Foundation
import RealmSwift

class Weather: Object {
    
    dynamic var dt = ""
    dynamic var dayTemp = 0
    dynamic var minTemp = 0
    dynamic var maxTemp = 0
    dynamic var nightTemp = 0
    dynamic var eveTemp = 0
    dynamic var mornTemp = 0
    dynamic var pressure = 0.0
    dynamic var humidity = 0
    dynamic var icon = ""
    dynamic var speedWind = 0.0
}

class CityWeather: Object {
    
    dynamic var id = 0
    dynamic var name = ""
    var list = List<Weather>()
}
