//
//  SelfProfileViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 12/3/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class SelfProfileViewController: UIViewController {
    
    // Properties

    @IBOutlet weak var lblNameProfile: UILabel!
    @IBOutlet weak var lblMealPlan: UILabel!
    @IBOutlet weak var lblMuteMode: UILabel!
    @IBOutlet weak var lblEmailProfile: UILabel!
    @IBOutlet weak var lblMateType: UILabel!
    @IBOutlet weak var lblCollegeProfile: UILabel!
    
    
    //Methods
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        let uid = Auth.auth().currentUser?.uid
        
            Database.database().reference().child("USERS/\(uid!)").observe(.value, with: { snapshot in
            // get the entire snapshot dictionary
            if let dictionary = snapshot.value as? [String: Any]
            {
                var fullName = (dictionary["firstName"] as? String)! + " " + (dictionary["lastName"] as? String)!
                var mealPlan = (dictionary["mealPlan"] as? Bool)!
                var muteMode = (dictionary["muteMode"] as? Bool)!
                var email = (dictionary["email"] as? String)!
                var mateType = (dictionary["mateType"] as? String)!
                var college = (dictionary["college"] as? String)!
                
                //String assignments
                    self.lblNameProfile.text = "\(fullName)"
                    self.lblEmailProfile.text = "\(email)"
                    self.lblMateType.text = "\(mateType)"
                    self.lblCollegeProfile.text = "\(college)"
                
                //Bool assignments
                    //mealPlan
                    if mealPlan == true {
                        self.lblMealPlan.text = "Meal Plan"
                    }
                    else
                    {
                        self.lblMealPlan.text = " "
                    }
                
                    //muteMode
                    if muteMode == true {
                        self.lblMuteMode.text = "Mute Mode"
                    }
                    else
                    {
                        self.lblMuteMode.text = " "
                    }
            }
        })
            
            
            
//            let value = snapshot.value as? NSDictionary
//                self.lblEmailProfile.text = (value?["email"] as? String)!
//                self.lblNameProfile.text = (value?["firstName"] as? String)!
        
//                self.muteMode = (value?["muteMode"] as? Bool)!
        
//        let profileImgRef = storageRef.child("profilePhotos/\(uid)/profileImage.png")
//        profileImgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//            if error != nil {
//                // Error
//            } else {
//                let profileImage = UIImage(data: data!)
//                self.imgUserPhoto.image = profileImage
//            }
//            })
//            { (error) in
//                print(error.localizedDescription)
//        }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
