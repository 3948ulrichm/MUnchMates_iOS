//
//  EditProfileViewCell.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 2/18/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit

// class for cell in tableView for EditProfileViewController
class EditProfileViewCell: UITableViewCell {

    // outlets
    @IBOutlet weak var lblEditProfileButtonName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

