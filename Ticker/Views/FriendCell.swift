//
//  FriendCell.swift
//  Ticker
//
//  Created by Samuel Beek on 05-03-15.
//  Copyright (c) 2015 Tosti. All rights reserved.
//
import UIKit

class FriendCell : UITableViewCell {
    
    var nameLabel : UILabel!
    var statusLabel: UILabel!
    var user: User!
    var askButton: UIButton!


    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameLabel = UILabel(frame: CGRectMake(ptp(32), ptp(24), ptp(500), ptp(60)))
        nameLabel.font = roboto
        nameLabel.textColor = gray
        self.contentView.addSubview(nameLabel)
        
        statusLabel = UILabel(frame: CGRectMake(ptp(32), ptp(34), ptp(500), ptp(60)))
        statusLabel.font = roboto
        self.contentView.addSubview(statusLabel)
        
        askButton = UIButton(frame: CGRectMake(self.contentView.frame.width - ptp(100), ptp(0), ptp(100),self.contentView.frame.height))
        askButton.setTitle("Ask", forState: .Normal)
        askButton.titleLabel!.font = boldFont
        askButton.backgroundColor = greenColor
        askButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.contentView.addSubview(askButton)
        
        if(self.user != nil){
            layout()
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func layoutSubviews() {
        layout()
    }
    
    //sets the content
    func setData(user: User){
//        self.user = user
    }
    
    func layout() {
        askButton.frame = CGRectMake(self.contentView.frame.width - ptp(100), ptp(0), ptp(100),self.contentView.frame.height)
        statusLabel.frame = CGRectMake(ptp(32), ptp(34), ptp(500), ptp(60))
        
        nameLabel.text = "\(self.user.firstName) \(self.user.lastName)"
        
        if(user.status != nil) {
            self.askButton.hidden = true
            self.statusLabel.text = user.status
            
            self.nameLabel.font = UIFont(name: "Roboto-Light", size: ptp(26))
            self.nameLabel.frame = CGRectMake(ptp(17), ptp(6), ptp(254),ptp(30))
            
        }

    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        //        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }




}