//
//  RegisterViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 10/9/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    // This is used to shorten code later in the class (to see an example of this, command + f and search "userNodeRef.")
    let userNodeRef = Database.database().reference().child("USERS")

    // Outlets
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var switchMealPlan: UISwitch!
    
    // Global variables
    var mealPlanBool: Bool = false
    let userT = Auth.auth().currentUser
    
    // Whether or not a user has a meal plan is set when registering. This is expressed by toggling a switch. If the switch is on, mealPlanBool is true and the user does have a meal plan. If the switch is off, mealPlanBool is false and the user does not have a meal plan. When the register button is clicked, this bool gets sent to the database.
    @IBAction func switchMealPlanAction(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            mealPlanBool = true
        }
        else {
            mealPlanBool = false
        }
    }

    // When this is pressed, the user will be registered if the checks below pass. The user still will need to verify their email address in order to login. From this view controller, the user is sent to a pledge.
    @IBAction func btnRegister(_ sender: Any) {
   
        // CHECK that no text fields are nil
        if txtFirstName.text != "" && txtLastName.text != "" && txtEmail.text != "" && txtPassword.text != "" {
            
            // Put text field values into strings, set placholder values, and get meal plan bool value.
            if
                let firstName = txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                let lastName = txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                let email = txtEmail.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
                let password = txtPassword.text,
                let muteMode:Bool = false,
                let mealPlan:Bool = self.mealPlanBool,
                let mateType:String = "¯\\_(ツ)_/¯",
                let college:String = "¯\\_(ツ)_/¯",
                let city:String = "",
                let stateCountry:String = "",
                let emailNotifications:Bool = true
            {

                // CHECK that email is marquette email address
                if email.lowercased().hasSuffix("marquette.edu") || email.lowercased().hasSuffix("mu.edu") {
                    
                    // ADD: CHECK if email is already in database
                    // Currently, if all of the checks pass but the account fails to get created, we assume the email being used is already in the database. So, a popup displays that says the email is already in our database, but that check will not always be correct. It will be helpful to add a check here to see if the email address being used is already in the database.
                        
                    
                        // CHECK that password has more than five characters. Firebase requires more than 5 characters or the accounts will not get created.
                        if password.count > 5 {
                        
                        // Add user to Firebase Authentication
                            Auth.auth().createUser(withEmail:email, password: password, completion: {user,error in
                            
                            // Add user to Firebase Database
                            if user != nil {
                                let uid: String? = (Auth.auth().currentUser?.uid)!
                                //  SearchOrderNumber is randomly generated every time a user opens the filter view controller (home page). The purpose of the number was to randomly order search results when users searched "all" but bc we have changed the search "all" to forcing a user to select a specific attribute for their search this number is not used. It might be able to be used in the future though!
                                let searchOrderNumber = Int(arc4random_uniform(UInt32(100000)))
                                // lastOpened is refreshed every time a user opens the filter view controller (home page). The purpose of this user attribute is to see how long it has been since a user has last used the app. This gets overwritten each time a user opens the app, so we don't see how often someone uses the app, but in the future we can query users that haven't used the app since X date and use it to help us minimize inactive accounts.
                                let lastOpened = NSDate().timeIntervalSince1970
                                let userValues:[String:Any] =
                                    ["firstName": firstName,
                                     "lastName": lastName,
                                     "email": email,
                                     "muteMode": muteMode,
                                     "mealPlan": mealPlan,
                                     "mateType": mateType,
                                     "college": college,
                                     "uid": uid!,
                                     "city":city,
                                     "stateCountry":stateCountry,
                                     "searchOrderNumber":searchOrderNumber,
                                     "lastOpened":lastOpened,
                                     "emailNotifications":emailNotifications]
                                self.userNodeRef.child((user?.uid)!).updateChildValues(userValues, withCompletionBlock: {(userDBError, userDBRef) in
                                })
                                
                                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                changeRequest?.displayName = firstName + " " + lastName
                                changeRequest?.commitChanges { (error) in
                                    // ...
                                }
                                
                                // Email verification email sent to user
                                Auth.auth().currentUser?.sendEmailVerification { (error) in
                                    // ...
                                }
                                
                                // If all checks pass, user is segued to PledgeViewController
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PledgeViewController")
                                self.present(vc!, animated: true, completion: nil)
                            }
                            else {
                                // NOTE - This message will display for any error (outside of what we already check for). For now, this is the message that will be displayed because it will be the most common reason for a registration error but in the future, we should add a check that checks if an email is already registered in our database and make this an "Unknown Error", bc we don't truly know the root cause of the error for this alert.
                                let alertController = UIAlertController(title: "Registration Error!", message: "This email already exists in our database! If you have not previously made an account with this address, contact MUnchMatesHelpDesk@gmail.com", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        })}
                            
                        // ALERT for password needing more than 5 characters
                        else {
                            let alertController = UIAlertController(title: "Registration Error!", message: "Password must be greater than 5 characters!", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                
                    
                    
                    // ADD - ALERT for email already being in the Db

                    
                // ALERT for needing a marquette email address
                else {
                    let alertController = UIAlertController(title: "Registration Error!", message: "Must contain marquette.edu or mu.edu email address!", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

            
        // ALERT for needing all text fields populated
        else {
            let alertController = UIAlertController(title: "Registration Error!", message: "All text fields must be filled!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // This is the function that gets called to add "done" button for dismissing the keyboard
    @objc func doneClicked() {
        view.endEditing(true)
    }
        
    override func viewDidLoad() {
        
        // Add done function on keyboard
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        doneButton.tintColor = UIColor.MUnchMatesBlue
        
        toolBar.setItems([doneButton], animated: false)
        
        txtFirstName.inputAccessoryView = toolBar
        txtLastName.inputAccessoryView = toolBar
        txtEmail.inputAccessoryView = toolBar
        txtPassword.inputAccessoryView = toolBar

        // Disable autocorrect for email and password textbox
        txtEmail.autocorrectionType = .no
        txtPassword.autocorrectionType = .no

        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This prevents the app from automatically selecting any of the textboxes when loading.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
