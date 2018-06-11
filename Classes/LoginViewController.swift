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
    
    // In this class, there is an autologin feature for users already logged into their MUnchMates account. Previously, this autologin feature would login users coming from the welcome page, whether or not they had verified their email address. The struct below will sends a bool that is true if the user is coming from the Welcome Page. If so, the user will not be auto-login and will need to verify their email before getting into their account.
    var doNotAutoLoginLoginPage = FromWelcomePageStruct()

    // Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLoginOutlet: UIButton!
    
    // Action: Button can be pressed to send reset password email to user. When button is clicked an email is sent to the email address in the txtEmail
    @IBAction func btnForgotPassword(_ sender: Any) {
        
        // if there is no text in the email textbox, an alert displays telling the user to put their email in the email textbox. The email in the textbox will be the email a "new password" email gets sent to when the "Forgot Password" button is pressed.
        if txtEmail.text == "" {
            let alertController = UIAlertController(title: "Input email!", message: "Input your Marquette email into the textbox above and click this button again. We will send you an email to reset your password!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Got it!", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
            
        // If txtEmail.text is not blank, an email gets sent to the email address that was typed into txtEmail.text
        else {
            // declare email variable
            var email: String?
            
            // make email vairable equal to the text in the email text box
            email = txtEmail.text
            
            // reset password email sent
            Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                }
            
            // alert pops up telling user that an email was sent
            let alertController = UIAlertController(title: "Email sent!", message: "A password reset email has been sent to \(email!)", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Thank you!", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // action for when login button is pressed
    @IBAction func btnLogin(_ sender: Any) {
        
        // code trims any spaces before and after email. Email is not case sensitive, but the password is.
        if let email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = txtPassword.text {
            
            // checks to see if email and password combination is in our database.
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                // checks if user's email exists AND is not verified. If the email exists and is not verified, an ALERT pops up that the user needs to verify their email
                if user?.isEmailVerified == false {
                    let alertController = UIAlertController(title: "Login Failed!", message: "Email needs to be verified!", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Alright, I'm on it!", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                // if user's email/password combination exists and the email is verfied, the user is logged in and segued to the home page (FilterViewController)
                else if user != nil {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController")
                        self.present(vc!, animated: true, completion: nil)
                    }
                    
                // If the email is not in Firebase Auth OR the email exists (and is verifed) but the email/password combination does not exist, this ALERT pops up
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
    
    // this prevents app selecting txtEmail and txtPassword when view controller loads
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // checks if user is coming from welcome page view controller. If so, this code prevents an auto-login, because we want the user to verify their email before being logged in. Going forward, the user will be auto logged in when they open the app.
        if doNotAutoLoginLoginPage.fromWelcomePage == true {
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        // if the user is not coming from the welcome page and the user was previously logged in, this will auto log in the user
        else{
            handle = Auth.auth().addStateDidChangeListener(){ (auth, user) in
                if user != nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController")
                    self.present(vc!, animated: true, completion: nil)
                }
            }
        }
        
        // disables autocorrect for textfields
        txtEmail.autocorrectionType = .no
        txtPassword.autocorrectionType = .no
        
    }
    
    // these commands happen when vc is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creates toolbar for "done" button, which released keyboard
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        // adds done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        // makes color of button "MUnchMatesBlue", which was defined in UIExtensions.swift and exactly matches our logo's blue color
        doneButton.tintColor = UIColor.MUnchMatesBlue
        toolBar.setItems([doneButton], animated: false)
        
        // adds toolbar with done button to keyboard that appears for txtEmail and txtPassword
        txtEmail.inputAccessoryView = toolBar
        txtPassword.inputAccessoryView = toolBar
    }
    
    // action for done button that was created in viewDidLoad()
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    // sent to the view controller when the app receives a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
