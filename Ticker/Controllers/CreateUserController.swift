//
//  ViewController.swift
//  Ticker
//
//  Created by Samuel Beek on 05-03-15.
//  Copyright (c) 2015 Tosti. All rights reserved.
//

import UIKit


class CreateUserController: UIViewController, UITextFieldDelegate {
    
    var nameField, phoneField : TickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackScreen("create")
        // MARK: Create User Form
        var welcomeLabel = UILabel(frame: CGRectMake(ptp(216), ptp(264), ptp(318), ptp(43)))
        welcomeLabel.text = "Welcome to Ticker"
        welcomeLabel.font = labelFont
        welcomeLabel.textColor = UIColor.blackColor()
        self.view.addSubview(welcomeLabel)
        
        var nameLabel  = UILabel(frame: CGRectMake(ptp(162), ptp(370), ptp(95), ptp(43)))
        nameLabel.text = "name"
        nameLabel.font = labelFont
        nameLabel.textColor = darkGray
        self.view.addSubview(nameLabel)
        
        nameField                   = TickerTextField(frame: CGRectMake(ptp(162), ptp(426), ptp(426), ptp(82)))
        nameField.delegate = self
        self.view.addSubview(nameField)

        var phoneLabel  = UILabel(frame: CGRectMake(ptp(162), ptp(540), ptp(108), ptp(43)))
        phoneLabel.text = "phone"
        phoneLabel.font = labelFont
        phoneLabel.textColor = darkGray
        self.view.addSubview(phoneLabel)
        
        phoneField                   = TickerTextField(frame: CGRectMake(ptp(162), ptp(596), ptp(426), ptp(81)))
        phoneField.delegate = self
        self.view.addSubview(phoneField)
        
        var createButton = UIButton(frame: CGRectMake(ptp(248),ptp(740),ptp(255),ptp(43)))
        createButton.setTitle("Create", forState: .Normal)
        createButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            createButton.addTarget(self, action: "createAccount", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(createButton)
    
    }

    func createAccount(){
        // resign first responders
        nameField.resignFirstResponder()
        phoneField.resignFirstResponder() 
        
        // create user and go to the homeviewcontroller
        createUser(nameField.text, phoneField.text) { success in
            if(success) {
                var home: HomeViewController = HomeViewController()
                var navigationController = UINavigationController(rootViewController: home)
                self.presentViewController(navigationController, animated: true, completion: nil)
            } else {
                println("there was no user created")
            }
        }
        
    }
    


}

func trackScreen(name: String){}

