//
//  HomeViewController.swift
//  Ticker
//
//  Created by Samuel Beek on 05-03-15.
//  Copyright (c) 2015 Tosti. All rights reserved.
//

import UIKit

class HomeViewController : UITableViewController, UITableViewDelegate {
    let addressBook = APAddressBook()
    var friends : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar Styling
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.topItem?.title = "Contacts"
        
        self.tableView.delegate = self
        
        tableView.registerClass(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        configureAddressBook()
        
        loadContacts()
    }
    
    func loadContacts(){
        self.addressBook.loadContacts(
            { (contacts: [AnyObject]!, error: NSError!) in
                if (contacts != nil) {
                    
                    // log contact information
                    for contact in contacts {

                        var user: User = User()
                        var firstName = "\(contact.firstName)"
                        var lastName = "\(contact.lastName)"
                        var phones = contact.phones
                        
                        // if it's nil, set to none
                        if (firstName == "nil") { firstName = ""}
                        if (lastName == "nil") { lastName = "" }

                        
                        user.firstName = firstName
                        user.lastName = lastName
                        user.phoneNumber = contact.phones
                        user.favourite = false
                        user.tickerMember = false
                        
                        // if the user has no first or last name (i.e. is a company 
                        // or unknown user) don't save it
                        if(!(firstName == "" && lastName == "")) {
                            self.friends.append(user)
                        }
                    }
                    
                    println(self.friends)
                    self.tableView.reloadData()
                }
                else if (error != nil) {
                    // show error
                }
        })
    }
    
    //MARK: Table Functions
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return friends.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //connect sell to tableview
        var cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendCell
        
        cell.setData(friends[indexPath.row])

        return cell
    }

    
    //MARK: Configurations
    func configureAddressBook() {
        
        //filter contacts on the ones you have phone numbers of
        self.addressBook.filterBlock = {(contact: APContact!) -> Bool in
            return contact.phones.count > 0
        }
        
        //sort contacts by first name
        self.addressBook.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true),
            NSSortDescriptor(key: "lastName", ascending: true)]
        
        //load only first name, last name and phone, for pictures, add: | APContactField.Thumbnail
        self.addressBook.fieldsMask = APContactField.Default

    }
}