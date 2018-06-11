//
//  ProfileMessageViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/13/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

// this class / view controller displays profile of user that the current user is having a conversation with. the only way to get to this vc is from MessageViewController.
class ProfileMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // global variables
    let storageRef =  Storage.storage().reference()
    let dataRef = Database.database().reference()
    var userProfileImageSearch: UIImage?
    let cellId = "ClubsOrgsCellProfileMessage"
    let uidSelf = Auth.auth().currentUser?.uid
    
    // user data and filter data
    //DELETE: var userDetails = SearchUsers()
    var getFromMessageToProfile: [UserInConversations] = []
    var fromMessageToProfile = SearchUsers() // stores info of profile user (not current user)
    var fromUserMessageProfile = UserInConversations()
    //DELETE: var filterDataProfile = FilterVCToSearchVCStruct()
    
    //MARK - Struct
    var clubsOrgsProfile: [clubsOrgsStruct] = []
    // DELETE: var selfUserClubsOrgsProfile = clubsOrgsStruct()
    
    //MARK - outlets
    @IBOutlet weak var lblNameProfileSearch: UILabel!
    @IBOutlet weak var lblMealPlanSearch: UILabel!
    @IBOutlet weak var imgProfilePictureSearch: UIImageView!
    @IBOutlet weak var lblHometownSearch: UILabel!
    @IBOutlet weak var lblMateTypeProfileSearch: UILabel!
    @IBOutlet weak var lblCollegeProfileSearch: UILabel!
    @IBOutlet weak var lblMuteMode: UILabel!
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // viewWillAppear. this is where data gets loaded to vc.
    override func viewWillAppear(_ animated: Bool) {
        
        // uid of user who's profile it is (not current user)
        let uid:String = fromMessageToProfile.uid
        
        // display clubsOrgs in tableView
        dataRef.child("USERS/\(uid)/clubsOrgs/").queryOrdered(byChild:"clubsOrgsName").observe(.value, with:
            { snapshot in
                
                var fireAccountArray: [clubsOrgsStruct] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = clubsOrgsStruct(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                }
                
                self.clubsOrgsProfile = fireAccountArray
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                
        })
        
        // put all user data, except for clubsOrgs and profilePic, into a snapshot dictionary
        dataRef.child("USERS/\(uid)").observe(.value, with: { snapshot in
            // get the entire snapshot dictionary
            if let dictionary = snapshot.value as? [String: Any]
            {
                // put dictionary values into local variables
                var fullName = (dictionary["firstName"] as? String)! + " " + (dictionary["lastName"] as? String)!
                var firstName = (dictionary["firstName"] as? String)!
                var mealPlan = (dictionary["mealPlan"] as? Bool)!
                var muteMode = (dictionary["muteMode"] as? Bool)!
                var email = (dictionary["email"] as? String)!
                var mateType = (dictionary["mateType"] as? String)!
                var college = (dictionary["college"] as? String)!
                
                // MUteMode
                if muteMode == true {
                    self.lblMuteMode.text = "\(firstName) is in MUteMode!"
                }
                else {
                    self.lblMuteMode.isHidden = true
                }
                
                
                // HOMETOWN. we give the option to leave city and stateCountry blank, so based on what the user has input will change how it is displayed.
                // if neither city or stateCountry is blank, label will display "city, stateCountry"
                var hometown:String?
                if (dictionary["city"] as? String)! != "" && (dictionary["stateCountry"] as? String)! != "" {
                    hometown = (dictionary["city"] as? String)! + ", " + (dictionary["stateCountry"] as? String)!
                    self.lblHometownSearch.text = "\(hometown!)"
                }
                    // if city is blank and stateCountry not, label will display "stateCountry"
                else if (dictionary["city"] as? String)! == "" && (dictionary["stateCountry"] as? String)! != "" {
                    var hometown = (dictionary["stateCountry"] as? String)!
                    self.lblHometownSearch.text = "\(hometown)"
                }
                    //if stateCountry is blank and city is not, label will display "city"
                else if (dictionary["city"] as? String)! != "" && (dictionary["stateCountry"] as? String)! == "" {
                    var hometown = (dictionary["city"] as? String)!
                    self.lblHometownSearch.text = "\(hometown)"
                }
                    //if city and stateCountry are both blank (or anything else), label will be blank
                else {
                    var hometown = ""
                    self.lblHometownSearch.text = "\(hometown)"
                }
                
                // string assignments
                self.lblNameProfileSearch.text = "\(fullName)"
                self.lblMateTypeProfileSearch.text = "\(mateType)"
                self.lblCollegeProfileSearch.text = "\(college)"
                
                // bool assignments
                // mealPlan
                if mealPlan == true {
                    self.lblMealPlanSearch.text = "Meal Plan"
                }
                else
                {
                    self.lblMealPlanSearch.text = " "
                }
            }
        })
        
        // load profile picture
        let profileImgRef = storageRef.child("imgProfilePictures/\(uid).png")
        profileImgRef.getData(maxSize: 50 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Image does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(uid).png")!) as Data?
                    // user's profile picture is named their uid followed by ".png". for example, if Tim is the user and has a uid of "abc123", Tim's profile picture file name will be "abc123.png". this makes it easily accessible when Tim is using the app, bc all we need to do is call his uid.
                    let imagePath = "imgProfilePictures/\(uid).png"
                    
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/png"
                    
                    self.storageRef.child(imagePath)
                        .putData(profileImageData!, metadata: metaData) { (metadata, error) in
                            if let error = error {
                                print ("Uploading Error: \(error)")
                                return
                            }
                    }
                    self.userProfileImageSearch = UIImage(named: "\(uid).png")
                } else {
                    return
                }
            } else {
                self.userProfileImageSearch = UIImage(data: data!)
                self.imgProfilePictureSearch.image = self.userProfileImageSearch
            }
        }
    } // end of viewWillAppear

    // table view. for user's clubsOrgs.
    // how many sections does the table view have (this will create mutilple results. for example, if you return 2 and have five results, ten results will show up with with 1st being the same as the 6th, the 2nd being the same as the 7th, etc.)?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // how many rows?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubsOrgsProfile.count
    }
    
    // what will display in each cell? clubsOrgsNames.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ProfileMessageTableViewCell
        let clubOrgInfo = self.clubsOrgsProfile[indexPath.row]
        cell.lblClubsOrgs.text = clubOrgInfo.clubsOrgsName
        return cell
        
    }
    
    // what happens if you select a row? nothing in this case. in the future, i think it would be very cool to have clubsOrgs pages that have a discription for each club and a list of people in the club. when you select a club on a user's profile, it will take you to this clubsOrgs overview page. work on an Android app first, but down the road, this could be a powerful idea for the app!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // variables for message button action
    var uid:String = " "
    var userDisplayName:String = " "
    
    // ACTION: back button. this will pass information about current user (this is unnecessary but I didnt realize that when I did it. current user info does not need to be passed from vc to vc bc you will always have access to a current user's uid, and if you have the current user's uid you are able to access any data you need.) and user who's profile is is back to the message vc.
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "ProfileMessage2Message", sender: self)
    }
    
    // segue from profile message vc to message vc. passes current user and profile user data back to message vc.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileMessage2Message" {
            let vc = segue.destination as! MessageViewController
            vc.toUser = fromMessageToProfile
            vc.fromUserMessage = fromUserMessageProfile
        }
    }
    
    // sent to the view controller when the app receives a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
