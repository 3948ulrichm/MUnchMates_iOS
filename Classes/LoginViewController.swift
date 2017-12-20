//
//  LoginViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 10/9/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
        
    @IBAction func btnLogin(_ sender: Any) {

        if let email = txtEmail.text, let password = txtPassword.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                //Segue to FilterViewController
                if user != nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController")
                    self.present(vc!, animated: true, completion: nil)
                }
                
                //ALERT for login error
                else {
                    let alertController = UIAlertController(title: "Login Failed!", message: "Incorrect username or password!", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener(){ (auth, user) in
            if user != nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController")
                self.present(vc!, animated: true, completion: nil)
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

