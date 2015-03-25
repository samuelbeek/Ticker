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
    var askButton: UIButton!
    
    var user: User! {
        didSet {
            self.layout()
        }
    }


    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame.size.height = ptp(150)
        
        nameLabel = UILabel(frame: CGRectMake(ptp(47), ptp(26), ptp(266), ptp(38)))
        nameLabel.font = UIFont(name: "Roboto-Bold", size: ptp(32))
        nameLabel.textColor = darkGray
        self.contentView.addSubview(nameLabel)
        
        statusLabel = UILabel(frame: CGRectMake(ptp(47), ptp(83), ptp(521), ptp(40)))
        statusLabel.font = UIFont(name: "Roboto-Regular", size: ptp(34))
        statusLabel.textColor = lightGray
        self.contentView.addSubview(statusLabel)
        
        askButton = UIButton(frame: CGRectMake(self.contentView.frame.width - ptp(166), ptp(0), ptp(166),self.contentView.frame.height))
        askButton.setTitle("Ask", forState: .Normal)
        askButton.titleLabel!.font = boldFont
        askButton.backgroundColor = greenColor
        askButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.contentView.addSubview(askButton)
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
        if (user != nil) {
            nameLabel.text = "\(self.user.firstName) \(self.user.lastName)"
            
            if(user.status != nil) {
                self.askButton.hidden = true
                self.statusLabel.text = "''\(user.status)''"
            } else {
                self.statusLabel.text = "click ask to know"
                self.askButton.hidden = false

            }
        }
        
        askButton.frame = CGRectMake(self.contentView.frame.width - ptp(160), ptp(0), ptp(160),self.contentView.frame.height)

        

    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        //        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }




}