//
//  WelcomeViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/13/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    var doNotAutoLoginWelcomePage = FromWelcomePageStruct()
    var fromWelcomePage = true


    @IBAction func btnGoToLoginPage(_ sender: Any) {
        doNotAutoLoginWelcomePage = FromWelcomePageStruct(fromWelcomePage:fromWelcomePage)
        performSegue(withIdentifier: "Welcome2Login", sender: self)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Welcome2Login" {
            let vc = segue.destination as! LoginViewController
            vc.doNotAutoLoginLoginPage = doNotAutoLoginWelcomePage
        }
    }
}
