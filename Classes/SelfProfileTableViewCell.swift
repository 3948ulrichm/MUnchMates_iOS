//
//  SelfProfileTableViewCell.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 1/25/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit

// class for cell in tableView for SelfProfileViewController
class SelfProfileTableViewCell: UITableViewCell {

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
