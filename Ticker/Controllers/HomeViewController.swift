//
//  HomeViewController.swift
//  Ticker
//
//  Created by Samuel Beek on 05-03-15.
//  Copyright (c) 2015 Tosti. All rights reserved.
//

import UIKit
import MessageUI


class HomeViewController : UITableViewController, UITableViewDelegate, MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate {
    let addressBook = APAddressBook()
    var friends : [User] = []
    var createBar: UIView!
    var statusField: TickerTextField!
    var selectedRow: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar Styling
        if let nav = self.navigationController {
            //nav.hidesBarsOnSwipe = true
            //nav.hidesBarsOnTap = true
            nav.navigationBarHidden = false
            nav.navigationBar.translucent = true
            nav.navigationBar.topItem?.title = "Contacts"
            nav.navigationBar.barTintColor = blueColor
            nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: font!]
            nav.popToRootViewControllerAnimated(true)
            
            //to make sure its always on top; the create bar should be added by the navigation controller
            createBar = UIView(frame: CGRectMake(0, self.view.frame.size.height - ptp(52), self.view.frame.size.width, ptp(300)))
            createBar.backgroundColor = blueColor
            
            statusField = TickerTextField(frame: CGRectMake(ptp(15), ptp(15), createBar.frame.width - ptp(30), ptp(70)))
            statusField.layer.borderWidth = 0
            statusField.placeholder = "update your status"
            statusField.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
            statusField.delegate = self
            createBar.addSubview(statusField)
            nav.view.addSubview(createBar)
        }
        
        self.tableView.delegate = self
        
        // important: register the class of our cell as the main cell
        tableView.registerClass(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        tableView.rowHeight = ptp(120)
        
        configureAddressBook()
        loadContacts()
    }
    
    func loadContacts(){
        self.addressBook.loadContacts(
            { (contacts: [AnyObject]!, error: NSError!) in
                if (contacts != nil) {
                    
                    // get contact information
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
                        if(count(firstName) % 5 == 0){
                            user.status = "Drinking @ De Pels"
                        }
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
    
    // MARK: Actions
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        var actions = UIActionSheet()
        actions.addButtonWithTitle("close")
        actions.addButtonWithTitle("call")
        actions.addButtonWithTitle("text")
        actions.addButtonWithTitle("add to favourites")
        actions.cancelButtonIndex = 0;
        actions.showInView(self.navigationController?.view)
        actions.delegate = self

    }
    
    func actionSheet(actions: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        println(buttonIndex)
        var phone = friends[selectedRow].phoneNumber[0] as! String
        println("phone")
        println(phone)
        
        
        switch buttonIndex{
            case 1:
                self.call(phone)
            case 2:
                sendMessage("Yo!", phoneNumber: phone)
            case 3:
                println("adding to favorites")
            default:
                println("default")
        }
    }

    
    func ask(sender: UIButton){
        println(friends[sender.tag].firstName)
        var user = friends[sender.tag]
        
        if  ((user.favourite == nil)) {
            
            println("send a noticiation")
            
        } else {
            sendMessage("wat ben je aan het doen?", phoneNumber: user.phoneNumber)
        }
    }
    
    func sendText(sender: UIButton) {
        sendMessage("", phoneNumber: friends[sender.tag].phoneNumber)
    }
    
    func call(phoneNumber: String){
        println(phoneNumber)
        var phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        var url : NSURL = NSURL(string:"tel://\(phoneNumber)")!
        UIApplication.sharedApplication().openURL(url)
    }

    
    func sendMessage(message: String, phoneNumber: AnyObject){
        dispatch_async(dispatch_get_main_queue()) {
            var messageController : MFMessageComposeViewController = MFMessageComposeViewController()
            
            if (!MFMessageComposeViewController.canSendText()) {
                var warningAlert : UIAlertView = UIAlertView.alloc();
                warningAlert.title = "Error";
                warningAlert.message = "Your device does not support SMS.";
                warningAlert.delegate = nil;
                warningAlert.show();
                return;
            }
            
            var recipients : NSArray = ["\(phoneNumber)"];
            
            messageController.messageComposeDelegate = self;
            messageController.recipients = recipients as! [AnyObject];
            messageController.body = message;
            
            self.presentViewController(messageController, animated: true, completion: nil);
        }
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
        var cell = tableView.dequeueReusableCellWithIdentifier("FriendCell") as? FriendCell
        
//        if cell == nil {
//            println("nil cell")
//            UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "FriendCell")
//        }
        
        
        println("\(friends[indexPath.row].firstName) - \(friends[indexPath.row].status)")
        cell?.askButton.tag = indexPath.row //TO DO: is there a better way?
        cell?.askButton.addTarget(self, action: "ask:", forControlEvents: UIControlEvents.TouchUpInside)
        cell?.user = friends[indexPath.row]
        cell?.layout()
        return cell!
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
    
    // MARK:  MFMessageViewController Delegate
    
    // opens the message view controller and checks if it's canceld.
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        if (result.value == MessageComposeResultCancelled.value) {
            NSLog("Message was cancelled.");
        }
        else if (result.value == MessageComposeResultFailed.value) {
            var warningAlert : UIAlertView = UIAlertView.alloc();
            warningAlert.title = "Error";
            warningAlert.message = "Failed to send SMS!";
            warningAlert.delegate = nil;
            warningAlert.show();
            NSLog("Message failed.");
        } else {
            NSLog("Message was sent.");
        }
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    //MARK: TextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        self.tableView.userInteractionEnabled = false
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.createBar.frame.origin.y = self.view.frame.size.height - (ptp(700))
        })

    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.createBar.frame.origin.y = self.view.frame.size.height - (ptp(100))
        })
        self.tableView.userInteractionEnabled = true
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        println("return")
        textField.resignFirstResponder()
        
        return true
    }


    
}