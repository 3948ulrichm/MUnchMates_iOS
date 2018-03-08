//
//  AddDeleteClubsOrgsTableViewCell.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 1/30/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class AddDeleteClubsOrgsTableViewCell: UITableViewCell {
    
    var uid = Auth.auth().currentUser?.uid
    var cellClubOrgId:String?
    var viewControllerId = "AddDeleteClubsOrgsVC"
    //let cell = AddDeleteClubsOrgsViewController.passDataToCell()
    
    @IBOutlet weak var lblClubsOrgs: UILabel!
    @IBOutlet weak var switchClubsOrgs: UISwitch!
    
    
    //Add Delete Club / Org
    @IBAction func switchToggleClubsOrgs(_ sender: Any) {
        let clubsOrgsNameValue = self.lblClubsOrgs.text
        let clubsOrgsIdValue = self.cellClubOrgId!
        
        let clubsOrgsValues:[String:Any] =
            [
                "clubsOrgsName":clubsOrgsNameValue,
                "clubsOrgsId":clubsOrgsIdValue
            ]
        
        if (sender as AnyObject).isOn == true {
            Database.database().reference().child("USERS/\(uid!)/clubsOrgs/\(clubsOrgsIdValue)").setValue(clubsOrgsValues)
        }
        else {
            Database.database().reference().child("USERS/\(uid!)/clubsOrgs/\(cellClubOrgId!)").removeValue()
        }
        
        //Insert clubs org info into Db

        
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
