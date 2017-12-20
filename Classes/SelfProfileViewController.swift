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
    let storageRef = Storage.storage().reference()
    let dataRef = Database.database().reference()
    var userProfileImage: UIImage?
    let uid = Auth.auth().currentUser?.uid


    
    
    @IBOutlet weak var lblNameProfile: UILabel!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var lblMealPlan: UILabel!
    @IBOutlet weak var lblMuteMode: UILabel!
//    @IBOutlet weak var lblEmailProfile: UILabel!
    @IBOutlet weak var lblMateType: UILabel!
    @IBOutlet weak var lblCollegeProfile: UILabel!
    
    
    //Methods
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        
            dataRef.child("USERS/\(uid!)").observe(.value, with: { snapshot in
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
//                    self.lblEmailProfile.text = "\(email)"
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
                        self.lblMuteMode.text = "MUte Mode"
                    }
                    else
                    {
                        self.lblMuteMode.text = " "
                    }
            }
        })
        
        let profileImgRef = storageRef.child("imgProfilePictures/\(self.uid!).png")
        profileImgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Image does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uid!).png")!) as Data?
                    let imagePath = "imgProfilePictures/\(self.uid!).png"
                    
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/png"
                    
                    self.storageRef.child(imagePath)
                        .putData(profileImageData!, metadata: metadata) { (metadata, error) in
                            if let error = error {
                                print ("Uploading Error: \(error)")
                                return
                            }
                    }
                    self.userProfileImage = UIImage(named: "\(self.uid!).png")
                } else {
                    return
                }
            } else {
                self.userProfileImage = UIImage(data: data!)
                self.imgProfilePicture.image = self.userProfileImage
            }
        }
            
//        func displayContent() {
//            self.spinner.stopAnimating()
//
//            self.navigationItem.title = self.userInfo?.company
//
//
//            self.imgProfilePic.image = self.userProfileImage
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
