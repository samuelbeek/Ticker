//
//  API.swift
//  Ticker
//
//  Created by Samuel Beek on 16-03-15.
//  Copyright (c) 2015 Tosti. All rights reserved.
//

import Foundation
import SwiftHTTP
import SwiftyJSON


let apiURL = "http://54.77.128.20:8765"

func createUser(name: String, phoneNumber: String){
    
    println("creating user")

    var request = HTTPTask()
    request.requestSerializer = JSONRequestSerializer()
    request.responseSerializer = JSONResponseSerializer()

    //we have to add the explicit type, else the wrong type is inferred. See the vluxe.io article for more info.
    let params: Dictionary<String,AnyObject> = ["screenName": name, "phoneNumber": phoneNumber]
    request.POST("\(apiURL)/user/", parameters: params, success: {(response: HTTPResponse) in
            if let dict = response.responseObject as? Dictionary<String,AnyObject> {
                var jsonObject = dict
                var userID = jsonObject["id"]!
                println("object: \(jsonObject)")
                println("userID \(userID)")
                NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "userID")
                
            }
        },failure: {(error: NSError, response: HTTPResponse?) in
            println("error error: \(error)")
            println("error response: \(response)")
    })

}

func postStatus(status: String) {
    var userID : String = NSUserDefaults.standardUserDefaults().objectForKey("userID") as! String
    var phoneNumber : String  = NSUserDefaults.standardUserDefaults().objectForKey("phoneNumber")! as! String
    var screenName : String  = NSUserDefaults.standardUserDefaults().objectForKey("screenName")! as! String
    var request = HTTPTask()
    request.requestSerializer = JSONRequestSerializer()
    request.responseSerializer = JSONResponseSerializer()
    let params: Dictionary<String,AnyObject> = ["statusMessage": status]
    request.PUT("\(apiURL)/user/", parameters: params, success: {(response: HTTPResponse) in
        if let dict = response.responseObject as? Dictionary<String,AnyObject> {
            
        }
        },failure: {(error: NSError, response: HTTPResponse?) in
            println("error error: \(error)")
            println("error response: \(response)")
    })
    
    
}