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
    
    let userNodeRef = Database.database().reference().child("USERS")

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var switchMealPlan: UISwitch!
    var mealPlanBool: Bool = false
    let userT = Auth.auth().currentUser
    @IBAction func switchMealPlanAction(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            mealPlanBool = true
        }
        else {
            mealPlanBool = false
        }
    }

    @IBAction func btnRegister(_ sender: Any) {
   
        //CHECK that no fields are nil
        if txtFirstName.text != "" && txtLastName.text != "" && txtEmail.text != "" && txtPassword.text != "" {
            
            //put text field values into strings
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
                let stateCountry:String = ""
            {

                //CHECK that email is marquette email address
                if email.lowercased().hasSuffix("marquette.edu") || email.lowercased().hasSuffix("mu.edu") {
                    
                    //ADD: CHECK if email is already in database
                    //var fbEmail = Auth.auth().fetchProviders(email)
                    //if email != fbEmail {
                        
                    
                        //CHECK that password has more than five characters
                        if password.count > 5 {
                        
                        //add user to Firebase
                            Auth.auth().createUser(withEmail:email, password: password, completion: {user,error in
                            
                            //add user to Firebase Database
                            if user != nil {
                                let uid: String? = (Auth.auth().currentUser?.uid)!
                                let searchOrderNumber = Int(arc4random_uniform(UInt32(100000)))
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
                                     "lastOpened":lastOpened]
                                self.userNodeRef.child((user?.uid)!).updateChildValues(userValues, withCompletionBlock: {(userDBError, userDBRef) in
                                })
                                
                                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                changeRequest?.displayName = firstName + " " + lastName
                                changeRequest?.commitChanges { (error) in
                                    // ...
                                }
                                Auth.auth().currentUser?.sendEmailVerification { (error) in
                                    // ...
                                }
                                
                                //segue to PledgeViewController
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PledgeViewController")
                                self.present(vc!, animated: true, completion: nil)
                            }
                            else {
                                //NOTE - While this message will display for any error, for now this is the message that will be displayed because it will be the most common reason for a registration error
                                let alertController = UIAlertController(title: "Registration Error!", message: "This email already exists in our database! If you have not previously made an account with this address, contact MUnchMatesHelpDesk@gmail.com", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        })}
                            
                        //ALERT for password needing more than 5 characters
                        else {
                            let alertController = UIAlertController(title: "Registration Error!", message: "Password must be greater than 5 characters!", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                
                    
                    
                //ALERT for email already being in the Db
//                else{
//                    let alertController = UIAlertController(title: "Registration Error!", message: "Email already exists in database! If you have not previously made an account with this address contact MUnchMatesMarquette@gmail.com", preferredStyle: UIAlertControllerStyle.alert)
//                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
//                    }
//                    alertController.addAction(okAction)
//                    self.present(alertController, animated: true, completion: nil)
//                }
            //}
                    
            //ALERT for needing a marquette email address
                else {
                    let alertController = UIAlertController(title: "Registration Error!", message: "Must contain marquette.edu or mu.edu email address!", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

            
        //ALERT for needing all text fields populated
        else {
            let alertController = UIAlertController(title: "Registration Error!", message: "All text fields must be filled!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
        
    override func viewDidLoad() {
        
        //add done function on keyboard
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        doneButton.tintColor = UIColor.MUnchMatesBlue
        
        toolBar.setItems([doneButton], animated: false)
        
        txtFirstName.inputAccessoryView = toolBar
        txtLastName.inputAccessoryView = toolBar
        txtEmail.inputAccessoryView = toolBar
        txtPassword.inputAccessoryView = toolBar

        //disable autocorrect
        txtEmail.autocorrectionType = .no
        txtPassword.autocorrectionType = .no

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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


//TODO
    //convert emails to all lowercase when they enter db
