//
//  PreloaderView.swift
//  Weather
//
//  Created by Dmitriy Yavorskiy on 19.11.16.
//  Copyright © 2016 Dmitriy Yavorskiy. All rights reserved.
//

import Foundation
import UIKit

struct PreloaderView {
    
    public static func preloaderView(view: UIView, indicator: Bool) -> UIView {
        
        let messageFrame = UIView(frame: CGRect(x: view.frame.midX - 70, y: view.frame.midY - 90, width: 140, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
        let strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = "Loading"
        strLabel.textColor = UIColor.black
        
        if indicator {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        
        messageFrame.addSubview(strLabel)
        
        return messageFrame
    }
}
