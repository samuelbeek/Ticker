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
    var user: User!


    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        nameLabel = UILabel(frame: CGRectMake(ptp(32), ptp(24), ptp(300), ptp(40)))
        self.contentView.addSubview(nameLabel)
        
        // self.contentView.addSubview(rightArrow)
        
    }
    
    //sets the content
    func setData(user: User){
        self.user = user
        nameLabel.text = "\(self.user.firstName) \(self.user.lastName)"
    
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        //        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }




}