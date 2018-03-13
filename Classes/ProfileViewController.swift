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
    
    let storageRef =  Storage.storage().reference()
    let dataRef = Database.database().reference()
    var userProfileImageSearch: UIImage?
    let cellId = "ClubsOrgsCellProfile"
    let uidSelf = Auth.auth().currentUser?.uid
    
    //MARK - user data and filter data
    var userDetails = SearchUsers()
//********
    var getFromUser: [UserInConversations] = []
    var fromUserProfile = UserInConversations()
    var filterDataProfile = FilterVCToSearchVCStruct()

    //MARK - Struct
    var clubsOrgsProfile: [clubsOrgsStruct] = []
    var selfUserClubsOrgsProfile = clubsOrgsStruct()

    //MARK - outlets
    @IBOutlet weak var lblNameProfileSearch: UILabel!
    @IBOutlet weak var lblMealPlanSearch: UILabel!
    @IBOutlet weak var imgProfilePictureSearch: UIImageView!
    @IBOutlet weak var lblHometownSearch: UILabel!
    @IBOutlet weak var lblMateTypeProfileSearch: UILabel!
    @IBOutlet weak var lblCollegeProfileSearch: UILabel!
    @IBOutlet weak var lblMuteMode: UILabel!
    @IBOutlet weak var btnMessageOutlet: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }

    
    ////////////LOAD INFORMATION TO SCREEN///////////////////
    override func viewWillAppear(_ animated: Bool) {

        let uid:String = userDetails.uid

        //display clubsOrgs
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


        //pull user data, except for clubsOrgs and profilePic
        dataRef.child("USERS/\(uid)").observe(.value, with: { snapshot in
            // get the entire snapshot dictionary
            if let dictionary = snapshot.value as? [String: Any]
            {
                var fullName = (dictionary["firstName"] as? String)! + " " + (dictionary["lastName"] as? String)!
                var firstName = (dictionary["firstName"] as? String)!
                var mealPlan = (dictionary["mealPlan"] as? Bool)!
                var muteMode = (dictionary["muteMode"] as? Bool)!
                var email = (dictionary["email"] as? String)!
                var mateType = (dictionary["mateType"] as? String)!
                var college = (dictionary["college"] as? String)!

                //MUteMode
                if muteMode == true {
                    self.btnMessageOutlet.isEnabled = false
                    self.lblMuteMode.text = "\(firstName) is in MUteMode and cannot be messaged!"
                }
                else {
                    self.btnMessageOutlet.isEnabled = true
                    self.lblMuteMode.isHidden = true
                }
                
                
                //assign hometown
                //if neither blank
                var hometown:String?
                if (dictionary["city"] as? String)! != "" && (dictionary["stateCountry"] as? String)! != "" {
                    hometown = (dictionary["city"] as? String)! + ", " + (dictionary["stateCountry"] as? String)!
                    self.lblHometownSearch.text = "\(hometown!)"
                }
                    //if city blank, stateCountry not
                else if (dictionary["city"] as? String)! == "" && (dictionary["stateCountry"] as? String)! != "" {
                    var hometown = (dictionary["stateCountry"] as? String)!
                    self.lblHometownSearch.text = "\(hometown)"
                }
                    //if stateCountry blank, city not
                else if (dictionary["city"] as? String)! != "" && (dictionary["stateCountry"] as? String)! == "" {
                    var hometown = (dictionary["city"] as? String)!
                    self.lblHometownSearch.text = "\(hometown)"
                }
                    //if city and stateCountry are blank (or anything else)
                else {
                    var hometown = ""
                    self.lblHometownSearch.text = "\(hometown)"
                }

                //String assignments
                self.lblNameProfileSearch.text = "\(fullName)"
                self.lblMateTypeProfileSearch.text = "\(mateType)"
                self.lblCollegeProfileSearch.text = "\(college)"

                //Bool assignments
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

          //pull profpic
        let profileImgRef = storageRef.child("imgProfilePictures/\(uid).png")
        profileImgRef.getData(maxSize: 50 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Image does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(uid).png")!) as Data?
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
    //table view - clubsOrgs
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubsOrgsProfile.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ProfileTableViewCell
        let clubOrgInfo = self.clubsOrgsProfile[indexPath.row]
        cell.lblClubsOrgs.text = clubOrgInfo.clubsOrgsName
        return cell

    }

    //What happens if you select a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    var uid:String = " "
    var userDisplayName:String = " "

    @IBAction func btnMessagePressed(_ sender: Any) {
        
        var read:Bool = true
        var timeStamp: Double = 0.00
            fromUserProfile = UserInConversations(
                read:read,
                timeStamp:timeStamp,
                uid:uidSelf!,
                userDisplayName:(Auth.auth().currentUser?.displayName)!
            )

        let myVC = storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        myVC.toUser = userDetails
        myVC.fromUserMessage = fromUserProfile
        self.present(myVC, animated: true)
        
        //performSegue(withIdentifier: "Profile2Message", sender: self)
    }
    
    @IBAction func btnBack(_ sender: Any) {

        var entitySearch:String = filterDataProfile.entitySearch!
        var attributeSearch:String = filterDataProfile.attributeSearch!

        filterDataProfile = FilterVCToSearchVCStruct(
            entitySearch:entitySearch,
            attributeSearch:attributeSearch
        )
        
        performSegue(withIdentifier: "ProfileToSearchList", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileToSearchList" {
            let vc = segue.destination as! SearchListViewController
            vc.filterDataSearch = filterDataProfile
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

