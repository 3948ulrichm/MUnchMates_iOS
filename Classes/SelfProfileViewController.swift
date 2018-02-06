//
//  SelfProfileViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 12/3/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class SelfProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    let storageRef = Storage.storage().reference()
    let dataRef = Database.database().reference()
    var userProfileImage: UIImage?
    let uid = Auth.auth().currentUser?.uid
    var clubsOrgs: [clubsOrgsStruct] = []
    var selectedClubOrg = clubsOrgsStruct()
    let cellId = "ClubsOrgsCell"


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
    
////////////LOAD INFORMATION TO SCREEN///////////////////
    override func viewDidLoad() {
        
            //display clubsOrgs
            dataRef.child("USERS/\(uid!)/clubsOrgs/").queryOrdered(byChild:"cname").observe(.value, with:
            { snapshot in
                
                var fireAccountArray: [clubsOrgsStruct] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = clubsOrgsStruct(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                }
                
                self.clubsOrgs = fireAccountArray
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()

            })
        
        
            //pull user data, except for clubsOrgs and profilePic
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
                //  self.lblEmailProfile.text = "\(email)"
                    self.lblMateType.text = "\(mateType)"
                    self.lblCollegeProfile.text = "\(college)"
                
                //Bool assignments
                    // mealPlan
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
        
        //pull profpic
        let profileImgRef = storageRef.child("imgProfilePictures/\(self.uid!).jpg")
        profileImgRef.getData(maxSize: 50 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Image does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uid!).jpg")!) as Data?
                    let imagePath = "imgProfilePictures/\(self.uid!).jpg"
                    
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpg"
                    
                    self.storageRef.child(imagePath)
                        .putData(profileImageData!, metadata: metaData) { (metadata, error) in
                            if let error = error {
                                print ("Uploading Error: \(error)")
                                return
                            }
                    }
                    self.userProfileImage = UIImage(named: "\(self.uid!).jpg")
                } else {
                    return
                }
            } else {
                self.userProfileImage = UIImage(data: data!)
                self.imgProfilePicture.image = self.userProfileImage
            }
        }
        
        
        //URL method
//        if let url = NSURL(string: "https...") {
//            if let data = NSData(contentsOf: url as URL) {
//                imgProfilePicture.contentMode = UIViewContentMode.scaleAspectFit
//                imgProfilePicture.image = UIImage(data: data as Data)
//            }
//        }

//        let profileImgRef = storageRef.child("imgProfilePictures/\(self.uid!).jpg")
//        profileImgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//            if error != nil {
//                let errorDesc = error?.localizedDescription
//                if errorDesc == "Image does not exist." {
//                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uid!).jpg")!) as Data?
//                    let imagePath = "imgProfilePictures/\(self.uid!).jpg"
//
//                    let metadata = StorageMetadata()
//                    metadata.contentType = "image/jpg"
//
//                    self.storageRef.child(imagePath)
//                        .putData(profileImageData!, metadata: metadata) { (metadata, error) in
//                            if let error = error {
//                                print ("Uploading Error: \(error)")
//                                return
//                            }
//                    }
//                    self.userProfileImage = UIImage(named: "\(self.uid!).jpg")
//                } else {
//                    return
//                }
//            } else {
//                self.userProfileImage = UIImage(data: data!)
//                self.imgProfilePicture.image = self.userProfileImage
//            }
//        }
        

        super.viewDidLoad()
        
        }
    
    //table view - clubsOrgs
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubsOrgs.count
    }   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! SelfProfileTableViewCell
        let clubOrgInfo = self.clubsOrgs[indexPath.row]
        
        //Display club / org
        cell.lblClubsOrgs?.text = clubOrgInfo.cname
        return cell
        
    }
    
    var cname:String = " "
    
    //added by awebber to add c
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cname = self.clubsOrgs[indexPath.row].cname
        
        //selectedClubOrg = clubsOrgsStruct(cname: cname)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
