//
//  ConversationTableViewCell.swift
//  MUnchMates
//
//  Created by Andrew Webber on 3/8/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit

// class for cell in tableView for ConversationTableViewController
class ConversationTableViewCell: UITableViewCell {

    // outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUnread: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
