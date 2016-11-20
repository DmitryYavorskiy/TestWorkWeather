//
//  AlertController.swift
//  Weather
//
//  Created by Dmitriy Yavorskiy on 20.11.16.
//  Copyright © 2016 Dmitriy Yavorskiy. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    public static func createAlert(error: Int) -> UIAlertController {
        
        let errorMessage = ErrorCode.error(statusCode: error)
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction) in
            print("press ok")
        }))
        
        return alert
        
    }
}
