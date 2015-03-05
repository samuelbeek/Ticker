//
//  TickerTextfield.swift
//  Ticker
//
//  Created by Samuel Beek on 05-03-15.
//  Copyright (c) 2015 Tosti. All rights reserved.



import UIKit

class TickerTextField : UITextField {
    var leftMargin : CGFloat = 10.0
    
     override init(frame: CGRect){
       super.init(frame: frame)
        self.layer.borderColor = darkGray.CGColor
        self.layer.borderWidth = 1

        
    }

     required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftMargin
        return newBounds
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftMargin
        return newBounds
    }
}

