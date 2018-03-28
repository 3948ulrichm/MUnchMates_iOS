//
//  MessageTableViewCell.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/26/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    //put labels here
    @IBOutlet weak var lblSenderName: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

