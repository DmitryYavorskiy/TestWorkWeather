//
//  CurrentDayWeek.swift
//  Weather
//
//  Created by media-pt on 18.11.16.
//  Copyright © 2016 Dmitriy Yavorskiy. All rights reserved.
//

import Foundation

public struct CurrentDayWeek {
    
    public static func getDayOfWeek(_ today: Int) -> String? {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = Date(timeIntervalSince1970: Double(today))
        let dateString = formatter.string(from: date)
        
        if let todayDate = formatter.date(from: dateString) {
            
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDayIndex = myCalendar.component(.weekday, from: todayDate)
            let weekText = weekDayByIndex(index: weekDayIndex)
            
            return weekText
            
        } else {
            
            return nil
        }
    }
    
    private static func weekDayByIndex(index: Int) -> String? {
        
        switch index {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            print("Error weekDayByIndex")
            return nil
        }
    }
}
