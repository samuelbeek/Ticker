//
//  File.swift
//  Wildcard
//
//  Created by Samuel Beek on 29-01-15.
//  Copyright (c) 2015 Wildcard. All rights reserved.
//
import UIKit

var statusBar = false

extension UIViewController {
     func prefersStatusBarHidden() -> Bool {
        if(iPhone4){return true}
        return statusBar
    }
    
    func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}