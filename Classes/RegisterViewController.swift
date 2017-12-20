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
    @IBAction func btnRegister_TouchUpInside(_ sender: Any) {
   
        //CHECK that no fields are nil
        if txtFirstName.text != "" && txtLastName.text != "" && txtEmail.text != "" && txtPassword.text != "" {
            
            //put text field values into strings
            if
                var firstName = txtFirstName.text,
                var lastName = txtLastName.text,
                var email = txtEmail.text?.lowercased(),
                let password = txtPassword.text,
                let muteMode:Bool = false,
                let mealPlan:Bool = false,
                var mateType:String = " ",
                var college:String = " "
            {

                
                //CHECK that email is marquette email address
                if email.lowercased().hasSuffix("marquette.edu") || email.lowercased().hasSuffix("mu.edu") {
                    
                    //ADD: CHECK if email is already in database
                    
                    
                        //CHECK that password has more than five characters
                        if password.count > 5 {
                        
                        //add user to Firebase
                        Auth.auth().createUser(withEmail:email, password: password, completion: {user,error in
                            
                            //add user to Firebase Database
                            if user != nil {
                                let userValues:[String:Any] = ["firstName": firstName, "lastName": lastName, "email": email, "muteMode": muteMode, "mealPlan": mealPlan, "mateType": mateType, "college": college]
                                self.userNodeRef.child((user?.uid)!).updateChildValues(userValues , withCompletionBlock: {(userDBError, userDBRef) in
                                })
                                
                                //segue to PledgeViewController
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PledgeViewController")
                                self.present(vc!, animated: true, completion: nil)
                            }
                            else {
                                //ADD: check error and show error message
                                }
                                })
                        }
                        
                        //ALERT for password needing more than 5 characters
                        else {
                            let alertController = UIAlertController(title: "Registration Error!", message: "Password must be greater than 5 characters!", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                    //ALERT for needing a marquette email address
                    else {
                        let alertController = UIAlertController(title: "Registration Error!", message: "Must contain marquette.edu or mu.edu email address!", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                }
                //ALERT for email already being in the Db

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

    override func viewDidLoad() {
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
