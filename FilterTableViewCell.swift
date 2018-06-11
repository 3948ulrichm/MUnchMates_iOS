//
//  FilterTableViewCell.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 2/17/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit

// class for cell in tableView for FilterViewController
class FilterTableViewCell: UITableViewCell {
    
    // outlets
    @IBOutlet weak var lblFilterButtonName: UILabel!
    
    override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
}

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
    }
}
