//
//  ProfileViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 12/13/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // global variables
    let storageRef =  Storage.storage().reference()
    let dataRef = Database.database().reference()
    var userProfileImageSearch: UIImage?
    let cellId = "ClubsOrgsCellProfile"
    let uidSelf = Auth.auth().currentUser?.uid
    var muteModeBool = false
    
    //user data and filter data
    var userDetails = SearchUsers()
    var filterDataProfile = FilterVCToSearchVCStruct()
    var profileClubsOrgsStruct = FilterStructClubsOrgs()


    // used to pass user data to message view controller if current user presses message button
    var fromUserProfile = UserInConversations()

    // used to get user's clubsOrgs for tableView in profile
    var clubsOrgsProfile: [clubsOrgsStruct] = []

    // outlets
    @IBOutlet weak var lblNameProfileSearch: UILabel!
    @IBOutlet weak var lblMealPlanSearch: UILabel!
    @IBOutlet weak var imgProfilePictureSearch: UIImageView!
    @IBOutlet weak var lblHometownSearch: UILabel!
    @IBOutlet weak var lblMateTypeProfileSearch: UILabel!
    @IBOutlet weak var lblCollegeProfileSearch: UILabel!
    @IBOutlet weak var lblMuteMode: UILabel!
    @IBOutlet weak var btnMessageOutlet: UIBarButtonItem!

    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // viewWillAppear. this is where the profile data is loaded.
    override func viewWillAppear(_ animated: Bool) {

        // get selected user's uid from userDetails, which was passed from search results vc
        let uid:String = userDetails.uid

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
                    self.muteModeBool = true
                    self.lblMuteMode.text = "\(firstName) is in MUteMode! You cannot start a new conversation!"
                }
                else {
                    self.muteModeBool = false
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
    }
    
    // table view. for user's clubsOrgs.
    // how many sections does the table view have (this will create mutilple results. for example, if you return 2 and have five results, ten results will show up with with 1st being the same as the 6th, the 2nd being the same as the 7th, etc.)?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // how many rows are needed?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubsOrgsProfile.count
    }
    
    // what is in each cell of the table view?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ProfileTableViewCell
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

    // ACTION: message button. when this is pressed, the current user will go to MessageViewController and will view their conversation with the user who's profile they were just on. if they have previosly had a conversation, old messages will display and "read" will change to true (if it was false previously). if they have not had a conversation, no messages will show up and nothing will change in the database until a conversation has been started.
    @IBAction func btnMessagePressed(_ sender: Any) {
        
        // if a user is in MUteMode, the current user will be unable to press the message button. if they do, a pop up will come up saying "You are unable to start a new conversation with a user in MUteMode". if the current user has previously had a conversation with the user, they are able to go to their conversations vc and continue to message the user in MUteMode.
        if self.muteModeBool == true {
            let alertController = UIAlertController(title: "MUteMode", message: "You are unable to start a new conversation with a user in MUteMode", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Alright!", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)        }
        
        // if the user is NOT in MUteMode, a struct will get created that will eventually get saved under "senderList" in the Database.
        else {
            var read:Bool = true
            var timeStamp: Double = 0.00
            fromUserProfile = UserInConversations(
                read:read,
                timeStamp:timeStamp,
                uid:uidSelf!,
                userDisplayName:(Auth.auth().currentUser?.displayName)!
            )
            // passes userDetails (including uid) and fromUserProfile data, which is the data about the current user.
            let myVC = storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
            myVC.toUser = userDetails
            myVC.fromUserMessage = fromUserProfile
            self.present(myVC, animated: true)
        }
    }
    
    // ACTION: back button. passes filter data and displays previous filter result in SearchListViewController.
    @IBAction func btnBack(_ sender: Any) {

        var entitySearch:String = filterDataProfile.entitySearch!
        var attributeSearch:String = filterDataProfile.attributeSearch!

        filterDataProfile = FilterVCToSearchVCStruct(
            entitySearch:entitySearch,
            attributeSearch:attributeSearch
        )
        
        performSegue(withIdentifier: "ProfileToSearchList", sender: self)
    }

    // segue going back to SearchListViewController and passing back data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileToSearchList" {
            let vc = segue.destination as! SearchListViewController
            vc.filterDataSearch = filterDataProfile
            vc.clubsOrgsArray2 = profileClubsOrgsStruct
        }
    }
    
    // sent to the view controller when the app receives a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
