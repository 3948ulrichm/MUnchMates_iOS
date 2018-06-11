//
//  ProfileMessageTableViewCell.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/13/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit

// class for cell in tableView for ProfileMessageViewController
class ProfileMessageTableViewCell: UITableViewCell {
    
    // outlets
    @IBOutlet weak var lblClubsOrgs: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
