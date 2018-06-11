//
//  WelcomeViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/13/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

// this view controller displays after the pledge view controller and is a part of registration. The goal of this page is to welcome the user and tell them that they need to verify their email before logging in. If a user clicks through this page and tries to login, an alert and will let them know that they need to verify their email before they will be able to log in.
class WelcomeViewController: UIViewController {
    
    // sends a "true" bool to the login vc to prevent auto login
    var doNotAutoLoginWelcomePage = FromWelcomePageStruct()
    var fromWelcomePage = true

    // when button is clicked, user goes to login vc
    @IBAction func btnGoToLoginPage(_ sender: Any) {
        doNotAutoLoginWelcomePage = FromWelcomePageStruct(fromWelcomePage:fromWelcomePage)
        // call segue
        performSegue(withIdentifier: "Welcome2Login", sender: self)
        }
    
    // this is the segue that will take the user to the login page. the "doNotAutoLoginWelcomePage" struct will send a "true" bool to the variable "doNotAutoLoginLoginPage" in the login vc to let the vc know that the user is coming from the welcome page. This will prevent an auto login from occuring.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Welcome2Login" {
            let vc = segue.destination as! LoginViewController
            vc.doNotAutoLoginLoginPage = doNotAutoLoginWelcomePage
        }
    }
}
