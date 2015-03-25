//
//  HomeViewController.swift
//  Ticker
//
//  Created by Samuel Beek on 05-03-15.
//  Copyright (c) 2015 Tosti. All rights reserved.
//

import UIKit
import MessageUI


class HomeViewController : UITableViewController, UITableViewDelegate, MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    let addressBook = APAddressBook()
    var friends : [User] = []
    var searchArray: [User] = []
    var searchController : UISearchController = UISearchController()
    var headerView : UIView!
    var contacts = [String: User]()
    var phonesArray = [String]()
    var createBar: UIView!
    var statusField: TickerTextField!
    var selectedRow: Int!
    var filters: SegmentedControl!
    var updateButton: UIButton!
    var searchIsActive = false
    var searching = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureKeyboard()
        
        trackScreen("home")
        
        // important: register the class of our cell as the main cell
        tableView.rowHeight = ptp(150)
        tableView.registerClass(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        tableView.autoresizesSubviews = true

        
        self.filters                 = SegmentedControl(frame: CGRectMake(0,0, self.view.frame.width, ptp(134)))
        filters.items                = ["favorites","contacts"]
        filters.selectedLabelColor   = greenColor
        filters.backgroundColor      = UIColor.fromRGB(0xdddddd)
        filters.unselectedLabelColor = darkGray
        filters.font                 = boldFont
        filters.layer.borderWidth    = 0
        filters.selectedIndex        = 0
        filters.addTarget(self, action: "filterDidChange:", forControlEvents: .ValueChanged)
        
        
        self.headerView = UIView(frame: CGRectMake(0,0,self.view.frame.width, ptp(226)))
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.addSubview(filters)
        
        self.tableView.tableHeaderView = headerView
        self.tableView.tableHeaderView?.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.layer.borderWidth  = 0
        self.tableView.tableHeaderView?.clipsToBounds = true
        //navigationBar Styling
        if let nav = self.navigationController {
            //nav.hidesBarsOnSwipe = true
            //nav.hidesBarsOnTap = true
            nav.navigationBarHidden = false
            nav.navigationBar.translucent = true
            nav.navigationBar.topItem?.title = "Ticker"
            nav.navigationBar.barTintColor = blueColor
            nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: font!]
            nav.popToRootViewControllerAnimated(true)
            
            //to make sure its always on top; the create bar should be added by the navigation controller
            createBar = UIView(frame: CGRectMake(0, self.view.frame.size.height - ptp(52), self.view.frame.size.width, ptp(300)))
            createBar.backgroundColor = blueColor
            
            statusField = TickerTextField(frame: CGRectMake(ptp(14), ptp(14), createBar.frame.width - ptp(80), ptp(71)))
            statusField.layer.cornerRadius = ptp(13)
            statusField.layer.borderWidth = 0
            statusField.font = boldFont
            statusField.attributedPlaceholder = NSAttributedString(string:"What are you up to?",
                attributes:[NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: boldFont!])
            statusField.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
            statusField.delegate = self
            
            self.updateButton = UIButton(frame: CGRectMake(createBar.frame.width - ptp(44), ptp(30), ptp(19), ptp(37)))
            updateButton.setImage(UIImage(named: "updateIcon"), forState: UIControlState.Normal)
            updateButton.addTarget(self, action: "updateStatus", forControlEvents: .TouchUpInside)
            updateButton.alpha = 0
            createBar.addSubview(updateButton)
            createBar.addSubview(statusField)
            nav.view.addSubview(createBar)
            
            self.searchController = ({
                
                let controller = UISearchController(searchResultsController: nil)
                controller.searchResultsUpdater = self
                controller.hidesNavigationBarDuringPresentation = true
                controller.dimsBackgroundDuringPresentation = false
                controller.searchBar.searchBarStyle = .Minimal
                controller.searchBar.frame.origin.y = ptp(134)
                controller.searchBar.sizeToFit()
                controller.searchBar.barTintColor = UIColor.fromRGB(0xEEEEEE)
                controller.searchBar.delegate = self
                self.headerView.insertSubview(controller.searchBar, aboveSubview: self.filters)
                
                return controller
            })()
            
        }
        
        self.tableView.delegate = self
        // because the header view is on top of the cells

        configureAddressBook()
        loadContacts(true)
        
        let inset = UIEdgeInsetsMake(20, 0, 0, 0);
       // self.tableView.contentInset = inset;
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)

    }
    
    func animateCreateBar(height: CGFloat){
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.createBar.frame.origin.y = self.view.frame.size.height - (height + ptp(96))
            self.statusField.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
            self.updateButton.alpha = 1
            
        })

    }
    
    func finishEditing() {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.createBar.frame.origin.y = self.view.frame.size.height - (ptp(100))
            self.statusField.text = ""
            self.statusField.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
            self.updateButton.alpha = 0

        })
        self.tableView.userInteractionEnabled = true
    }

    
    func loadContacts(favorite: Bool){
        enableSearch(favorite)

        // get favorites if they exist
        var favorites : [String] = []
        if (NSUserDefaults.standardUserDefaults().objectForKey("favorites") != nil) {
            favorites = NSUserDefaults.standardUserDefaults().objectForKey("favorites") as! [String]
        }
        self.contacts = [String: User]()
        self.phonesArray = []
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
                        
                        user.firstName = firstName as! String
                        user.lastName  = lastName as! String
                        user.phoneNumber = contact.phones
                        user.favourite = false
                        user.tickerMember = false
                        if(!(firstName == "" && lastName == "")) {
                            var phoneNumber = user.phoneNumber[0] as! String
                            if(!favorite) {
                                self.phonesArray.append(phoneNumber)
                                self.contacts[phoneNumber] = user
                            } else {
                                if(contains(favorites, phoneNumber)){
                                    self.phonesArray.append(phoneNumber)
                                    self.contacts[phoneNumber] = user
                                }
                            }
                        }
                    }
                    
                    getStatusses(self.phonesArray, self.contacts){ contacts in
                        let newContacts : [User] = [User](contacts.values)
                        self.friends = newContacts.sorted { $0.firstName < $1.firstName }
                        dispatch_async(dispatch_get_main_queue(),{
                            self.tableView.reloadData()
                        });
                    }
                    
                    if (favorites.count == 0 && favorite == true){
                        self.alert("no favorites", message: "you can add favorites in contacts")
                    }
                    
                }
                else if (error != nil) {
                    // show error
                }
        })
    }
    
    func filterDidChange(sender: AnyObject?){
            switch filters.selectedIndex
            {
            case 0:
                trackScreen("favorites")
                loadContacts(true)

            case 1:
                trackScreen("home")
                loadContacts(false)
            default:
                break;
            }
    }

    func enableSearch(enable: Bool){
        var offset : CGFloat = 110
        if (enable == false) {
            offset  = 0
        }
        UIView.animateWithDuration(0.1, animations: {
            self.tableView.tableHeaderView?.frame.size.height = ptp(240-offset)
            self.headerView.frame.size.height = ptp(240-offset)
        })
        self.tableView.tableHeaderView = self.headerView

        self.tableView.setNeedsLayout()
        self.tableView.setNeedsDisplay()
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
    func actionSheet(actions: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        println(buttonIndex)
        var phone = ""
        if(searchController.active){
            phone = searchArray[selectedRow].phoneNumber[0] as! String
        } else {
            phone = friends[selectedRow].phoneNumber[0] as! String
        }
        println("phone")
        println(phone)
        
        
        switch buttonIndex{
            case 1:
                self.call(phone)
            case 2:
                sendMessage("Yo!", phoneNumber: phone)
            case 3:
                println("adding to favorites")
                addFavorites(phone) 
            default:
                println("default")
        }
    }

    func updateStatus(){
        var status = statusField.text
        statusField.resignFirstResponder()
        finishEditing()
        statusField.resignFirstResponder()

        postStatus(status)
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
        if (searchController.active) {
            return searchArray.count
        } else {
            return friends.count;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //connect sell to tableview
        var cell  = tableView.dequeueReusableCellWithIdentifier("FriendCell") as? FriendCell
        
        if cell == nil {
            println("nil cell")
            cell = FriendCell(style: UITableViewCellStyle.Default, reuseIdentifier: "FriendCell")
        }
        
        
        println("\(friends[indexPath.row].firstName) - \(friends[indexPath.row].status)")
        cell!.askButton.tag = indexPath.row //TO DO: is there a better way?
        cell!.askButton.addTarget(self, action: "ask:", forControlEvents: UIControlEvents.TouchUpInside)
        if(!searchController.active) {
            cell!.user = friends[indexPath.row]
        } else {
            cell!.user = searchArray[indexPath.row]
        }
        cell!.layout()
        cell!.layoutIfNeeded()
        
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
    
    func configureKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
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
    func textFieldDidBeginEditing(textField: UITextField) {
            self.tableView.userInteractionEnabled = false
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        updateStatus()
        statusField.resignFirstResponder()
        finishEditing()
        return false
    }

    func keyboardWillShow(notification: NSNotification) {
        if(!searchIsActive) {
            if let userInfo = notification.userInfo {
                    if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                        animateCreateBar(keyboardSize.height)
                    }
                }
        }
    }
    
    func alert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.searchArray.removeAll(keepCapacity: false)
        if (count(searchController.searchBar.text) > 0){
            let searchPredicate = NSPredicate(format: "(firstName CONTAINS[c] %@)", "\(searchController.searchBar.text)")
            let array : [User]  = (self.friends as NSArray).filteredArrayUsingPredicate(searchPredicate) as! [User]
            self.searchArray = array
        }
        self.tableView.reloadData()

    }
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchIsActive = true
        
        UIView.animateWithDuration(0.1, animations: {
            searchBar.frame.origin.y = 0
            self.filters.frame.size.height = 0
            self.tableView.tableHeaderView?.frame.size.height = ptp(240-90)
            self.headerView.frame.size.height = ptp(240-90)

        })
        self.tableView.tableHeaderView! = self.headerView
        
        return true
    }
    
    func searchBarDidEndEditing(searchBar: UISearchBar) -> Bool {
        leaveSearch()
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        leaveSearch()
    }
    
    func leaveSearch() {
        UIView.animateWithDuration(0.1, animations: {
            self.filters.frame.size.height = ptp(134)
            self.searchController.searchBar.frame.origin.y = ptp(174)
            self.tableView.tableHeaderView?.frame.size.height = ptp(240)
            self.headerView.frame.size.height = ptp(240)
        })
        self.tableView.tableHeaderView = self.headerView
        searchIsActive = false
    }

}
