//
//  ProfileViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 12/13/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var userDetails = SearchUsers()
    
    @IBOutlet weak var lblNameProfileSearch: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNameProfileSearch.text = userDetails.firstName + " " + userDetails.lastName
    }
    
}

