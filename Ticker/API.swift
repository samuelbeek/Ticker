//
//  API.swift
//  Ticker
//
//  Created by Samuel Beek on 16-03-15.
//  Copyright (c) 2015 Tosti. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftHTTP


let apiURL = "http://54.77.128.20:8765"

//MARK Status

func getStatusses(phoneNumbers: [String], contacts: [String: User] , callback: ([String: User]) -> ()) -> (){
    
    //parse the phone
    println(phoneNumbers)
    var request = HTTPTask()
    request.requestSerializer = JSONRequestSerializer()
    request.responseSerializer = JSONResponseSerializer()
    
    //we have to add the explicit type, else the wrong type is inferred. See the vluxe.io article for more info.
    let params: Dictionary<String,AnyObject> = ["phoneNumbers": phoneNumbers]
    request.POST("\(apiURL)/user/friendstatusses", parameters: params, success: {(response: HTTPResponse) in
       
        var responseJSON = JSON(response.responseObject!)
        println("repsone JSON: \(responseJSON)")
        
        // loop through the results
        for (index: String, receivedUser: JSON) in responseJSON {
            var phoneNumber = receivedUser["phoneNumber"].stringValue
            if let contact = contacts[phoneNumber] {
                contact.status = receivedUser["statusMessage"].stringValue
                contact.tickerMember = true
            }
        }
        
        callback(contacts)
        
        },failure: {(error: NSError, response: HTTPResponse?) in
            println("error error: \(error)")
            println("error response: \(response)")
//            callback(status: "")
    })
    
}

func poke(phoneNumber: String) {
    var fromPhoneNumber : String  = NSUserDefaults.standardUserDefaults().objectForKey("phoneNumber")! as String
    var toPhoneNumber: String = phoneNumber
    
    var request = HTTPTask()
    request.requestSerializer = JSONRequestSerializer()
    request.responseSerializer = JSONResponseSerializer()
    
    request.GET("\(apiURL)/user/poke/\(fromPhoneNumber)/\(toPhoneNumber)", parameters: nil, success: {(response: HTTPResponse) in
        if let dict = response.responseObject as? Dictionary<String,AnyObject> {

            
        }
        },failure: {(error: NSError, response: HTTPResponse?) in
            println("error error: \(error)")
            println("error response: \(response)")
            
    })
}

//MARK USER
func createUser(name: String, phoneNumber: String, callback: (Bool) -> ()) -> (){
    
    println("creating user")
    
    var request = HTTPTask()
    request.requestSerializer = JSONRequestSerializer()
    request.responseSerializer = JSONResponseSerializer()
    
    //we have to add the explicit type, else the wrong type is inferred. See the vluxe.io article for more info.
    let params: Dictionary<String,AnyObject> = ["screenName": name, "phoneNumber": phoneNumber, "statusMessage": ""]
    request.POST("\(apiURL)/user/", parameters: params, success: {(response: HTTPResponse) in
        if let dict = response.responseObject as? Dictionary<String,AnyObject> {
            var jsonObject = dict
            var userID : AnyObject? = jsonObject["id"]!
            println("object: \(jsonObject)")
            println("userID \(userID)")
//            setTrackedUserID("\(userID)")
            NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "userID")
            NSUserDefaults.standardUserDefaults().setObject(jsonObject["phoneNumber"]!, forKey: "phoneNumber")
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "status")
            NSUserDefaults.standardUserDefaults().setObject([], forKey: "favorites")

            NSUserDefaults.standardUserDefaults().setObject(jsonObject["screenName"]!, forKey: "screenName")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            callback(true)
            
        }
        },failure: {(error: NSError, response: HTTPResponse?) in
            println("error error: \(error)")
            println("error response: \(response)")
            
            callback(false)
    })
    
}


func updateUser(){
    var userID : AnyObject!     = NSUserDefaults.standardUserDefaults().objectForKey("userID")
    var phoneNumber : String    = NSUserDefaults.standardUserDefaults().objectForKey("phoneNumber")! as String
    var screenName : String     = NSUserDefaults.standardUserDefaults().objectForKey("screenName")! as String
    var favorites : [String]    = NSUserDefaults.standardUserDefaults().objectForKey("favorites") as [String]
    var status : String         = NSUserDefaults.standardUserDefaults().objectForKey("status")! as String
    var applePushToken : String = NSUserDefaults.standardUserDefaults().objectForKey("applePushToken")! as String
    
    var request = HTTPTask()
    request.requestSerializer = JSONRequestSerializer()
    request.responseSerializer = JSONResponseSerializer()
    let params: Dictionary<String,AnyObject> = ["id": userID, "screenName": screenName, "phoneNumber": phoneNumber, "statusMessage": status, "favorites" : favorites, "applePushToken": applePushToken]
    request.PUT("\(apiURL)/user/\(userID)", parameters: params, success: {(response: HTTPResponse) in
        println(request)
        if let dict = response.responseObject as? Dictionary<String,AnyObject> {
            
        }
        },failure: {(error: NSError, response: HTTPResponse?) in
            println("error error: \(error)")
            println("error response: \(response)")
    })
}


func addFavorites(phone: String){
    // create new array if there is none
    var favorites : [String] = []
    if (NSUserDefaults.standardUserDefaults().objectForKey("favorites") != nil) {
        favorites = NSUserDefaults.standardUserDefaults().objectForKey("favorites") as [String]
    }
    
    favorites.append(phone)
    NSUserDefaults.standardUserDefaults().setObject(favorites, forKey: "favorites")
    NSUserDefaults.standardUserDefaults().synchronize()
    updateUser()
}

func postStatus(status: String) {
    NSUserDefaults.standardUserDefaults().setObject(status, forKey: "status")
    NSUserDefaults.standardUserDefaults().synchronize()
    updateUser()
    
}
