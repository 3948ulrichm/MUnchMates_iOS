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
    
    // table view outlet. table view will display user's clubsOrgs
    @IBOutlet weak var tableView: UITableView!
    
    // variables
    let storageRef = Storage.storage().reference()
    let dataRef = Database.database().reference()
    var userProfileImage: UIImage?
    let uid = Auth.auth().currentUser?.uid
    let cellId = "ClubsOrgsCell"

    // structures
    // clubsOrgs
    var clubsOrgs: [clubsOrgsStruct] = []
    var selfUserClubsOrgs = clubsOrgsStruct()
    
    // this will either be true or false. if true, it means the "Update Headshot" button was clicked in EditProfileViewController (which we assume means the profile picture was updated). when the bool is true, this delays the userProfileImage from loading for five seconds to give time for the new image to upload and download to and from "Storage" in Firebase.
    var delayImageSelfProfile = DelayedImageLoadStruct()

    // Outlets
    @IBOutlet weak var lblNameProfile: UILabel!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var lblMealPlan: UILabel!
    @IBOutlet weak var lblMuteMode: UILabel!
    @IBOutlet weak var lblMateType: UILabel!
    @IBOutlet weak var lblCollegeProfile: UILabel!
    @IBOutlet weak var lblHometown: UILabel!
    @IBOutlet weak var lblLoadingNewImage: UILabel!
    
    // viewDidLoad. idk if this is needed bc we used viewWillAppear in this class. viewWillAppear is basically the same as viewDidLoad, but viewDidLoad is only called when a page loads. we tried switching everything to viewWillAppear to see if that fixed the issue we were running into of the old profile picture loading (this is before we decided to do the delay) hoping the image would switch in real time when the new image was uploaded to "Storage". viewWillAppear did not fix the issue but we still just kept everything in viewWillAppear.
    override func viewDidLoad()  {
        super.viewDidLoad()
    }
    
    // viewWillAppear. data that loads to vc.
    override func viewWillAppear(_ animated: Bool) {
        
        // lblLoadingNewImage is the label that displays when we delay the img from displaying in order to give time for a newly saved image to upload/download to/from Storage in Firebase. This label says something slong the lines of "loading your beautiful headshot!" this text can be changed in main.storyboard. lblLoadingNewImage starts of hidden unless a new image has just been saved, then it will display, which we will see later in the code.
        lblLoadingNewImage.isHidden = true
                
            // display clubsOrgs in table view
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
        
            // retieves all user's data (except for clubsOrgs and profilePic)
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
                
                // HOMETOWN. we give the option to leave city and stateCountry blank, so based on what the user has input will change how it is displayed.
                // if neither city or stateCountry is blank, label will display "city, stateCountry"
                var hometown:String?
                if (dictionary["city"] as? String)! != "" && (dictionary["stateCountry"] as? String)! != "" {
                    hometown = (dictionary["city"] as? String)! + ", " + (dictionary["stateCountry"] as? String)!
                    self.lblHometown.text = "\(hometown!)"
                }
                    
                // if city is blank and stateCountry not, label will display "stateCountry"
                else if (dictionary["city"] as? String)! == "" && (dictionary["stateCountry"] as? String)! != "" {
                    var hometown = (dictionary["stateCountry"] as? String)!
                    self.lblHometown.text = "\(hometown)"
                }
                    
                //if stateCountry is blank and city is not, label will display "city"
                else if (dictionary["city"] as? String)! != "" && (dictionary["stateCountry"] as? String)! == "" {
                    var hometown = (dictionary["city"] as? String)!
                    self.lblHometown.text = "\(hometown)"
                }
                    
                //if city and stateCountry are both blank (or anything else), label will be blank
                else {
                    var hometown = ""
                    self.lblHometown.text = "\(hometown)"
                }
                
                
                var city = (dictionary["city"] as? String)!
                var stateCountry = (dictionary["stateCountry"] as? String)!
                

                // label assignments
                    self.lblNameProfile.text = "\(fullName)"
                    self.lblMateType.text = "\(mateType)"
                    self.lblCollegeProfile.text = "\(college)"
                
                // bool assignments
                    // meal plan. if true, label says "Meal Plan", otherwise, it is blank.
                    if mealPlan == true {
                        self.lblMealPlan.text = "Meal Plan"
                    }
                    else
                    {
                        self.lblMealPlan.text = " "
                    }
                
                    // muteMode. if true, a gold strip will appear on lower half of vc with blue text saying "You are in MUteMode! Users cannot start a new conversation with you!", otherwise, it is blank.
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
        
        // PROFILE PICTURE
        // check if delayImageSelfProfile contains a "true" bool. if so, this means a new profile picture has likely been saved and imgProfilePicture will be delayed loading by five seconds to give time for the new image to upload/download to/from Storage in Firebase.
        if delayImageSelfProfile.savedImage! == true {
            // hide imgProfilePicture and display lblLoadingNewImage (label that says headshot is being uploaded)
            imgProfilePicture.isHidden = true
            lblLoadingNewImage.isHidden = false
            
        // load profile pic, delayed by 5 seconds to give time for the new image to upload/download to/from Storage in Firebase. Without delay, the user's old prof pic shows up until VC left and entered again.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.imgProfilePicture.isHidden = false
            self.lblLoadingNewImage.isHidden = true
            
            // download new prof pic
            let profileImgRef = self.storageRef.child("imgProfilePictures/\(self.uid!).png")
        profileImgRef.getData(maxSize: 50 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Image does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uid!).png")!) as Data?
                    
                    // user's profile picture is named their uid followed by ".png". for example, if Tim is the user and has a uid of "abc123", Tim's profile picture file name will be "abc123.png". this makes it easily accessible when Tim is using the app, bc all we need to do is call his uid.
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
            
            // unhide imgProfilePicture
            self.imgProfilePicture.isHidden = false
            })
        }
            
        // if delayImageSelfProfile is false. this will also download the image from Storage in Firebase, but it will not have a delay bc the profile picture did not change.
        else {
                let profileImgRef = self.storageRef.child("imgProfilePictures/\(self.uid!).png")
                profileImgRef.getData(maxSize: 50 * 1024 * 1024) { data, error in
                    if error != nil {
                        let errorDesc = error?.localizedDescription
                        if errorDesc == "Image does not exist." {
                            let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uid!).png")!) as Data?
                            
                            // user's profile picture is named their uid followed by ".png". for example, if Tim is the user and has a uid of "abc123", Tim's profile picture file name will be "abc123.png". this makes it easily accessible when Tim is using the app, bc all we need to do is call his uid.
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

    // table view - clubsOrgs
    // how many sections (this will create mutilple results. for example, if you return 2 and have five results, ten results will show up with with 1st being the same as the 6th, the 2nd being the same as the 7th, etc.)?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // how many rows in table view? this is decided by clubsOrgs struct created when downloading user's clubs and orgs from Firebase.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubsOrgs.count
    }   
    
    // what content is in the table view? only clubsOrgsName will display in each cell using a label.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! SelfProfileTableViewCell
        let clubOrgInfo = self.clubsOrgs[indexPath.row]
        
        // display club / org
        cell.lblClubsOrgs?.text = clubOrgInfo.clubsOrgsName
        return cell
        
    }
        // what happens if you select a row? nothing in this case. in the future, i think it would be very cool to have clubsOrgs pages that have a discription for each club and a list of people in the club. when you select a club on a user's profile, it will take you to this clubsOrgs overview page. work on an Android app first, but down the road, this could be a powerful idea for the app!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        }
    
    // sent to the view controller when the app receives a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
