//
//  SearchListViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 12/13/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class SearchListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
        
    let storageRef = Storage.storage()
    let dataRef = Database.database()
    let cellId = "SearchListTableViewCell"
    let uidSelf = Auth.auth().currentUser?.uid
//    let uid:String = ""
    var userProfileImage: UIImage?
    var mealPlanAttribute:Bool?
    
    //filterData struct
    //var filterSearch: [FilterVCToSearchVCStruct] = []
    var filterDataSearch = FilterVCToSearchVCStruct()
    var filterDataProfile = FilterVCToSearchVCStruct()

    //SearchUsers Struct
    var users: [SearchUsers] = []
    var selectedUser = SearchUsers()
    
    //SearchUsersProfilePic Struct
    //var usersProfilePic: [SearchUsersProfilePic] = []
    //var selectedUserProfilePic = SearchUsersProfilePic()
    
    //SearchUsersUid Struct
    //var usersUid: [SearchUsersUid] = []
    //var selectedUserUid = SearchUsersUid()
    
    //get clubs orgs data from filter
    var clubsOrgsArray: [FilterStructClubsOrgs]=[]
    var clubsOrgsArray2 = FilterStructClubsOrgs()
    
    //Filter Structs
    var filterCollege: [SearchUsers] = []
    var filterCollege2 = SearchUsers()

    var filterMateType: [SearchUsers] = []
    var filterMateType2 = SearchUsers()
    
    var filterMealPlan: [SearchUsers] = []
    var filterMealPlan2 = SearchUsers()
    
    var filterClubsOrgs: [SearchUsers] = []
    var filterClubsOrgs2 = SearchUsers()

    override func viewDidLoad() {
        
        var entitySearch:String = filterDataSearch.entitySearch!
        var attributeSearch:String = filterDataSearch.attributeSearch!
    
        //this randomizes searches when user searches for "All"
        var searchRandomOrderAttribute = ["college", "firstName", "lastName", "mateType", "uid"]
        var searchRandomOrderNumber = Int(arc4random_uniform(UInt32(searchRandomOrderAttribute.count)))
        print(searchRandomOrderNumber)
        
        //convert attributeSearch for mealPlan from yes/no to true/false
        if entitySearch == "meal plan" && attributeSearch == "Yes" {
            self.mealPlanAttribute = true
        }
        else if entitySearch == "meal plan" && attributeSearch == "No" {
            self.mealPlanAttribute = false
        }
        
//FILTERING...FILTERING...FILTERING...FILTERING...FILTERING...FILTERING!!!
        
        var clubsOrgsIdRef = clubsOrgsArray2.clubsOrgsId!
        print(clubsOrgsIdRef)
        
        if attributeSearch == "all" {
        dataRef.reference(withPath: "USERS/").queryOrdered(byChild:searchRandomOrderAttribute[searchRandomOrderNumber]).observeSingleEvent(of: .value, with:
            { snapshot in
                var fireAccountArray: [SearchUsers] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                    
                    //let clubsOrgsNames = fireAccount.map(){$0.clubsOrgsName}
                    
                    fireAccountArray.append(fireAccount)
                }

                self.users = fireAccountArray
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                super.viewDidLoad()
            })
        }
            
        //Filter by clubs orgs
        else if entitySearch == "club / organization" {
            dataRef.reference(withPath: "USERS/").queryOrdered(byChild:"clubsOrgs/\(String(describing: clubsOrgsIdRef))/clubsOrgsName").queryEqual(toValue: attributeSearch).observeSingleEvent(of: .value, with:
                { snapshot in
                    var fireAccountArray: [SearchUsers] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                        
                        //let clubsOrgsNames = fireAccount.map(){$0.clubsOrgsName}
                        
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.users = fireAccountArray
                    print("**************\(self.users)*******")
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    super.viewDidLoad()
            })
        }
            
        //Filter by colleges
        else if entitySearch == "college" {
            dataRef.reference(withPath: "USERS/").queryOrdered(byChild: "college").queryEqual(toValue: attributeSearch).observeSingleEvent(of: .value, with:
                { snapshot in
                    var fireAccountArray: [SearchUsers] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                        
                        //let clubsOrgsNames = fireAccount.map(){$0.clubsOrgsName}
                        
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.users = fireAccountArray
                    print("**************\(self.users)*******")

                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    super.viewDidLoad()
            })
        }
            
        //Filter by mate type
        else if entitySearch == "mate type" {
            dataRef.reference(withPath: "USERS/").queryOrdered(byChild: "mateType").queryEqual(toValue: attributeSearch).observeSingleEvent(of: .value, with:
                { snapshot in
                    var fireAccountArray: [SearchUsers] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                        
                        //let clubsOrgsNames = fireAccount.map(){$0.clubsOrgsName}
                        
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.users = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    super.viewDidLoad()
            })
        }
            
            
        //Filter by meal plan
        else if entitySearch == "meal plan" {
            dataRef.reference(withPath: "USERS/").queryOrdered(byChild: "mealPlan").queryEqual(toValue: mealPlanAttribute).observeSingleEvent(of: .value, with:
                { snapshot in
                    var fireAccountArray: [SearchUsers] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                        
                        //let clubsOrgsNames = fireAccount.map(){$0.clubsOrgsName}
                        
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.users = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    super.viewDidLoad()
            })
        }
        
        //
        
        
       
        //this is to text how many values are in each array

            super.viewDidLoad()
        
    }
    
    
    //set up table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! SearchListTableViewCell
        let userinfo = self.users[indexPath.row]
    
        //MUteMode?
        if userinfo.muteMode == true {
            cell.lblMUteMode?.text = "MUteMode"
        }
        else {
            cell.lblMUteMode?.isHidden = true
        }
    
        //Display full name
        cell.lblNameSearchList?.text = userinfo.firstName + " " + userinfo.lastName
    
        //Display mateType
        cell.lblMateTypeCollege?.text = userinfo.mateType + "  " + userinfo.college
    
        //Display mealPlan
        if userinfo.mealPlan == true {
            cell.lblMealPlan?.text = "M"
        }
        else {
            cell.lblMealPlan?.text = " "
        }
    
        //Display Profile Pictures
        let profileImgRef = storageRef.reference().child("imgProfilePictures/\(userinfo.uid).png")
        profileImgRef.getData(maxSize: 50 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Image does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(userinfo.uid).png")!) as Data?
                    let imagePath = "imgProfilePictures/\(userinfo.uid).png"
                    
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/png"
                    
                    self.storageRef.reference().child(imagePath)
                        .putData(profileImageData!, metadata: metaData) { (metadata, error) in
                            if let error = error {
                                print ("Uploading Error: \(error)")
                                return
                            }
                    }
                    self.userProfileImage = UIImage(named: "\(userinfo.uid).png")
                } else {
                    return
                }
            } else {
                self.userProfileImage = UIImage(data: data!)
                cell.imgProfilePic.image = self.userProfileImage
            }
        }
        return cell
    }
    
    var firstName:String = " "
    var lastName:String = " "
    var mealPlan:Bool = true
    var college:String = " "
    var mateType:String = " "
    var muteMode = false
    var uid:String = " "
    //var imgProfilePic:UIImageView? = nil
    
    //what happens when you select a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        firstName = self.users[indexPath.row].firstName
        lastName = self.users[indexPath.row].lastName
        mealPlan = self.users[indexPath.row].mealPlan
        mateType = self.users[indexPath.row].mateType
        muteMode = self.users[indexPath.row].muteMode
        uid = self.users[indexPath.row].uid
        
        
        selectedUser = SearchUsers(firstName: firstName, lastName: lastName,  mealPlan: mealPlan, mateType: mateType,muteMode:muteMode, college:college,uid:uid)

        //selectedUserProfilePic = SearchUsersProfilePic(imgProfilePic: imgProfilePic!)
        //selectedUserUid = SearchUsersUid(uid:uid)
        
        var entitySearch:String = filterDataSearch.entitySearch!
        var attributeSearch:String = filterDataSearch.attributeSearch!
        
        filterDataProfile = FilterVCToSearchVCStruct(
            entitySearch:entitySearch,
            attributeSearch:attributeSearch
        )
        
        performSegue(withIdentifier: "SearchList2Profile", sender: self)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "SearchList2Filter", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchList2Profile" {
            let vc = segue.destination as! ProfileViewController
            vc.userDetails = selectedUser
            vc.filterDataProfile = filterDataSearch
        }
        if segue.identifier == "SearchList2Filter" {
            let vc = segue.destination as! FilterViewController
            vc.filterData = filterDataSearch
        }
        
    }
}
