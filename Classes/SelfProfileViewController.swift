//
//  SelfProfileViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 12/3/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class SelfProfileViewController: UIViewController, UITableViewDelegate//, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // Properties
    let storageRef = Storage.storage().reference()
    let dataRef = Database.database().reference()
    var userProfileImage: UIImage?
    let uid = Auth.auth().currentUser?.uid
    var clubsOrgs: [clubsOrgsStruct] = []
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
    
    override func viewDidLoad() {
        
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
        
        //pull profpic
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
        
///////////HERE////////////clubsorgs table
//        Database.database().reference(withPath: "USERS/\(uid!)/clubsOrgs").observe(.value, with:
//            { snapshot in
//                var fireAccountArray: [clubsOrgsStruct] = []
//
//                for fireAccount in snapshot.children {
//                    let fireAccount = clubsOrgsStruct(snapshot: fireAccount as! DataSnapshot)
//                    fireAccountArray.append(fireAccount)
//                }
//
//                self.clubsOrgs = fireAccountArray
//
//                self.tableView.delegate = self;
//                self.tableView.dataSource = self;
//                self.tableView.reloadData()
//        })
//
//        super.viewDidLoad()
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return clubsOrgs.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! SelfProfileTableViewCell
//        let clubsorgsinfo = self.clubsOrgs[indexPath.row]
        
        //Display full name
//        cell.lblClubsOrgs?.text = clubsorgsinfo.name1
//
//        return cell
        
    }
    
    var name1:String = ""
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        name1 = self.clubsOrgs[indexPath.row].name1

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
