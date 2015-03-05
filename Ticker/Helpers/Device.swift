//
//  Device.swift
//  Wildcard
//
//  Created by Samuel Beek on 28/01/15.
//  Copyright (c) 2015 Wildcard. All rights reserved.
//

import UIKit

let iPhone4:     Bool = UIScreen.mainScreen().scale == 2.0 && UIScreen.mainScreen().bounds.size.height == 480.0
let iPhone5:     Bool = UIScreen.mainScreen().scale == 2.0 && UIScreen.mainScreen().bounds.size.height == 568.0
let iPhone6:     Bool = UIScreen.mainScreen().scale == 2.0 && UIScreen.mainScreen().bounds.size.height == 667.0
let iPhone6Plus: Bool = UIScreen.mainScreen().scale == 3.0 && UIScreen.mainScreen().bounds.size.height == 736.0