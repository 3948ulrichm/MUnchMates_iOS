//
//  AddDeleteClubsOrgsTableViewCell.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 1/30/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

// class for cell in tableView for AddDeleteClubsOrgsViewController
class AddDeleteClubsOrgsTableViewCell: UITableViewCell {
    
    // variables
    var uid = Auth.auth().currentUser?.uid
    var cellClubOrgId:String?
    var viewControllerId = "AddDeleteClubsOrgsVC"
    
    // outlets
    @IBOutlet weak var lblClubsOrgs: UILabel!
    @IBOutlet weak var switchClubsOrgs: UISwitch!
    
    
    // ACTION: toggling switches to add/delete club/org
    @IBAction func switchToggleClubsOrgs(_ sender: Any) {
        
        // put club/org name and id into variables
        let clubsOrgsNameValue = self.lblClubsOrgs.text
        let clubsOrgsIdValue = self.cellClubOrgId!
        
        // structure is used to store clubsOrgsName and clubsOrgsId. when switch is toggled, this structure gets saved or deleted from user's clubsOrgs node in the Firebase Database.
        let clubsOrgsValues:[String:Any] =
            [
                "clubsOrgsName":clubsOrgsNameValue,
                "clubsOrgsId":clubsOrgsIdValue
            ]
        
        // if switch is on, clubOrg gets added to user's clubsOrgs node in database. if switch is toggled off, clubOrg gets deleted from user's clubsOrgs node in database.
        if (sender as AnyObject).isOn == true {
            Database.database().reference().child("USERS/\(uid!)/clubsOrgs/\(clubsOrgsIdValue)").setValue(clubsOrgsValues)
        }
        else {
            Database.database().reference().child("USERS/\(uid!)/clubsOrgs/\(clubsOrgsIdValue)").removeValue()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
