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
    let cellId = "ClubsOrgsCell"

    //MARK - struct
    var clubsOrgs: [clubsOrgsStruct] = []
    var selfUserClubsOrgs = clubsOrgsStruct()
    
    var delayImageSelfProfile = DelayedImageLoadStruct()

    
    @IBOutlet weak var lblNameProfile: UILabel!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var lblMealPlan: UILabel!
    @IBOutlet weak var lblMuteMode: UILabel!
//    @IBOutlet weak var lblEmailProfile: UILabel!
    @IBOutlet weak var lblMateType: UILabel!
    @IBOutlet weak var lblCollegeProfile: UILabel!
    @IBOutlet weak var lblHometown: UILabel!
    @IBOutlet weak var lblLoadingNewImage: UILabel!
    
    //Methods
    override func viewDidLoad()  {

        
        super.viewDidLoad()
        
    }
    
////////////LOAD INFORMATION TO SCREEN///////////////////
    override func viewWillAppear(_ animated: Bool) {
        
        lblLoadingNewImage.isHidden = true
                
            //display clubsOrgs
            dataRef.child("USERS/\(uid!)/clubsOrgs/").queryOrdered(byChild:"clubsOrgsName").observe(.value, with:
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
                
                //assign hometown
                //if neither blank
                var hometown:String?
                if (dictionary["city"] as? String)! != "" && (dictionary["stateCountry"] as? String)! != "" {
                    hometown = (dictionary["city"] as? String)! + ", " + (dictionary["stateCountry"] as? String)!
                    self.lblHometown.text = "\(hometown!)"
                }
                //if city blank, stateCountry not
                else if (dictionary["city"] as? String)! == "" && (dictionary["stateCountry"] as? String)! != "" {
                    var hometown = (dictionary["stateCountry"] as? String)!
                    self.lblHometown.text = "\(hometown)"
                }
                //if stateCountry blank, city not
                else if (dictionary["city"] as? String)! != "" && (dictionary["stateCountry"] as? String)! == "" {
                    var hometown = (dictionary["city"] as? String)!
                    self.lblHometown.text = "\(hometown)"
                }
                //if city and stateCountry are blank (or anything else)
                else {
                    var hometown = ""
                    self.lblHometown.text = "\(hometown)"
                }
                
                
                var city = (dictionary["city"] as? String)!
                var stateCountry = (dictionary["stateCountry"] as? String)!
                
                

                
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
                        self.lblMuteMode.isHidden = false
                        self.lblMuteMode.text = "You are in MUteMode! Users cannot start a new conversation with you!"
                    }
                    else
                    {
                        self.lblMuteMode.isHidden = true
                        self.lblMuteMode.text = " "
                    }
                }
            })
        
        //pull profpic
        if delayImageSelfProfile.savedImage! == true {
            //CHECK - should print true
            print(delayImageSelfProfile.savedImage!)
            
        //Display loading picture label
            //hide prof pic
            imgProfilePicture.isHidden = true
            lblLoadingNewImage.isHidden = false
            
        //Load profile pic, delayed by 4 seconds. This is to give time for it to push and pull from storage in Firebase. Without  delay the old prof pic shows up until VC exited and entered again
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            
            self.imgProfilePicture.isHidden = false
            self.lblLoadingNewImage.isHidden = true
            
            //pull new prof pic
            let profileImgRef = self.storageRef.child("imgProfilePictures/\(self.uid!).png")
        profileImgRef.getData(maxSize: 50 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Image does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uid!).png")!) as Data?
                    let imagePath = "imgProfilePictures/\(self.uid!).png"
                    
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/png"
                    
                    self.storageRef.child(imagePath)
                        .putData(profileImageData!, metadata: metaData) { (metadata, error) in
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
            //unhide prof pic
            self.imgProfilePicture.isHidden = false
            })
        }
        else {
            //CHECK - should print false
                print(delayImageSelfProfile.savedImage!)
                let profileImgRef = self.storageRef.child("imgProfilePictures/\(self.uid!).png")
                profileImgRef.getData(maxSize: 50 * 1024 * 1024) { data, error in
                    if error != nil {
                        let errorDesc = error?.localizedDescription
                        if errorDesc == "Image does not exist." {
                            let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uid!).png")!) as Data?
                            let imagePath = "imgProfilePictures/\(self.uid!).png"
                            
                            let metaData = StorageMetadata()
                            metaData.contentType = "image/png"
                            
                            self.storageRef.child(imagePath)
                                .putData(profileImageData!, metadata: metaData) { (metadata, error) in
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
            }
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
        cell.lblClubsOrgs?.text = clubOrgInfo.clubsOrgsName
        return cell
        
    }
        
        //What happens if you select a row
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            

            
        }
    
//    var cname:String = " "
//    var cid:String = " "
//
//    cid = self.clubsOrgs[indexPath.row].cid
//    cname = self.clubsOrgs[indexPath.row].cname
//
//    selfUserClubsOrgs = clubsOrgsStruct(cname: cname, cid: cid)
//
//    performSegue(withIdentifier: "toEditProfile", sender: self)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditProfile" {
            let vc = segue.destination as! EditProfileViewController
            //vc.clubsOrgsDetails = selfUserClubsOrgs
        }
    }
    
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()

        }
    }
