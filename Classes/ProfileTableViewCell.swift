//
//  ProfileTableViewCell.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/2/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
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
