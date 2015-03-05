//
//  StylesHelper.swift
//  Ticker
//
//  Created by Samuel Beek on 05-03-15.
//  Copyright (c) 2015 Tosti. All rights reserved.
//

import UIKit

//styles
let labelFont = UIFont(name: "Roboto-Bold", size: ptp(36))
let roboto = UIFont(name: "Roboto-Regular", size: ptp(36))
let font = UIFont(name: "Roboto-Bold", size: ptp(36))
let boldFont = UIFont(name: "Roboto-Bold", size: ptp(36))

//colors
let darkGray = UIColor.fromRGB(0x4A4A4A)
let gray = UIColor.fromRGB(0x5E5E5E)
let blueColor = UIColor.fromRGB(0x1293F5)
let greenColor = UIColor.fromRGB(0x6EBE78)

// converts pixels (from your design, in sketch) into points
func ptp(float: CGFloat) -> CGFloat {
    
    if (iPhone5 || iPhone4) {
        return CGFloat((float/2)*0.845)
    }
    if (iPhone6Plus){
        return CGFloat((float/2)*1.104)
    }
    return CGFloat(float/2)
}


// support RGB colors, f.e. UIColor.fromRGB(0x71679B)
extension UIColor {
    
    class func fromRGB(rgb:UInt32) -> UIColor {
        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
