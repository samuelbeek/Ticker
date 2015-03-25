//
//  AppDelegate.swift
//  Ticker
//
//  Created by Samuel Beek on 05-03-15.
//  Copyright (c) 2015 Tosti. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let createUserViewController: CreateUserController = CreateUserController();
    let homeViewController: HomeViewController = HomeViewController();

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        self.window                         = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor        = UIColor.whiteColor()
        if(NSUserDefaults.standardUserDefaults().objectForKey("applePushToken") != nil){
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "applePushToken")
        }
        // if there's no user on the device, create a new one
        if(NSUserDefaults.standardUserDefaults().objectForKey("userID") != nil){
            
            var navigationController = UINavigationController(rootViewController: self.homeViewController)
            self.window!.rootViewController = navigationController
            
        } else {
            
            self.window!.rootViewController     = self.createUserViewController
        }
        
        self.window!.makeKeyAndVisible()
        
        return true
    }
    
    
    
    }

//MARK NOTIFICATIONS

func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
    var deviceString  = (("\(deviceToken)" as String).stringByReplacingOccurrencesOfString(" ", withString: "") as NSString)
    deviceString  = (("\(deviceString)" as String).stringByReplacingOccurrencesOfString("<", withString: "") as NSString)
    deviceString  = (("\(deviceString)" as String).stringByReplacingOccurrencesOfString(">", withString: "") as NSString)
    
    
    NSUserDefaults.standardUserDefaults().setObject(deviceString, forKey: "applePushToken")
    updateUser()
}

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        println("Couldn't register: \(error)")
    }

    func application(application: UIApplication!, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings!) {
        println("notifcation settings")
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: NSData) {
        
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }




