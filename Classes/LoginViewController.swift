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
    
    var doNotAutoLoginLoginPage = FromWelcomePageStruct()

    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLoginOutlet: UIButton!
    
    
    @IBAction func btnLogin(_ sender: Any) {

        if let email = txtEmail.text, let password = txtPassword.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if user?.isEmailVerified == false {
                    let alertController = UIAlertController(title: "Login Failed!", message: "Email needs to be verified!", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Alright, I'm on it!", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                    
                else if user != nil {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if doNotAutoLoginLoginPage.fromWelcomePage == true {
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        else{
            handle = Auth.auth().addStateDidChangeListener(){ (auth, user) in
                if user != nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController")
                    self.present(vc!, animated: true, completion: nil)
                }
            }
        }
        
        self.txtEmail.becomeFirstResponder()
        
        //disable autocorrect for textfields
        txtEmail.autocorrectionType = .no
        txtPassword.autocorrectionType = .no
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        
        txtEmail.inputAccessoryView = toolBar
        txtPassword.inputAccessoryView = toolBar

    }
    
    func doneClicked() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

