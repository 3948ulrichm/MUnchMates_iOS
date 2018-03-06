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
    
    @IBOutlet weak var testLabel: UILabel!
    
    let storageRef = Storage.storage()
    let dataRef = Database.database()
    let cellId = "SearchListCell"
    let uidSelf = Auth.auth().currentUser?.uid
//    let uid:String = ""
    var userProfileImage: UIImage?
    
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
        
        var mateTypeSearch:String = filterDataSearch.mateTypeSearch!
        var collegeSearch:String = filterDataSearch.collegeSearch!
        var mealPlanSearch:String = filterDataSearch.mealPlanSearch!
        var clubsOrgsSearch:String = filterDataSearch.clubsOrgsSearch!
        
        
//        var sid1:String = \(mateType)AllAllAll
//        var sid2:String = All\(college)AllAll
//        var sid3:String = AllAll\(mealPlan)All
//        var sid4:String = AllAllAll\(clubsOrgs)
//        var sid5:String = \(mateType)\(college)AllAll
//        var sid6:String = \(mateType)All\(mealPlan)All
//        var sid7:String = \(mateType)AllAll\(clubsOrgs)
//        var sid8:String = All\(college)\(mealPlan)All
//        var sid9:String = All\(college)All\(clubsOrgs)
//        var sid10:String = AllAll\(mealPlan)\(clubsOrgs)
//        var sid11:String = \(mateType)\(college)\(mealPlan)All
//        var sid12:String = \(mateType)\(college)All\(clubsOrgs)
//        var sid13:String = \(mateType)All\(mealPlan)\(clubsOrgs)
//        var sid14:String = All\(college)\(mealPlan)\(clubsOrgs)
//        var sid15:String = \(mateType)\(college)\(mealPlan)\(clubsOrgs)
//        var sid16:String = AllAllAllAll
    
        //filterMateType
        if mateTypeSearch == "All" {
        dataRef.reference(withPath: "USERS/").queryOrdered(byChild:"firstName").observeSingleEvent(of: .value, with:
            { snapshot in
                var fireAccountArray: [SearchUsers] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                }
                
                //TEMP
//                self.filterMateType = fireAccountArray
                self.users = fireAccountArray

                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                super.viewDidLoad()
            })
        }
        else {
            dataRef.reference(withPath: "USERS/").queryOrdered(byChild:"mateType").queryEqual(toValue: mateTypeSearch).observeSingleEvent(of: .value, with:
                { snapshot in
                    
                    var fireAccountArray: [SearchUsers] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.filterMateType = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    super.viewDidLoad()
                })
        }

        //filterCollege
        if collegeSearch == "All" {
            dataRef.reference(withPath: "USERS/").queryOrdered(byChild:"firstName").observeSingleEvent(of: .value, with:
                { snapshot in
                    var fireAccountArray: [SearchUsers] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.filterCollege = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    super.viewDidLoad()
            })
        }
        else {
            dataRef.reference(withPath: "USERS/").queryOrdered(byChild:"college").queryEqual(toValue: collegeSearch).observeSingleEvent(of: .value, with:
                { snapshot in
                    
                    var fireAccountArray: [SearchUsers] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.filterCollege = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    super.viewDidLoad()
            })
        }
        
        //filterMealPlan
        if mealPlanSearch == "All" {
            dataRef.reference(withPath: "USERS/").queryOrdered(byChild:"firstName").observeSingleEvent(of: .value, with:
                { snapshot in
                    var fireAccountArray: [SearchUsers] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.filterMealPlan = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    super.viewDidLoad()
            })
        }
        else {
            dataRef.reference(withPath: "USERS/").queryOrdered(byChild:"mealPlan").queryEqual(toValue: mealPlanSearch).observeSingleEvent(of: .value, with:
                { snapshot in
                    
                    var fireAccountArray: [SearchUsers] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.filterMealPlan = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    super.viewDidLoad()
            })
        }
        
        //filterClubsOrgs
//        if mateTypeSearch == "All" {
//            dataRef.reference(withPath: "USERS/").queryOrdered(byChild:"firstName").observeSingleEvent(of: .value, with:
//                { snapshot in
//                    var fireAccountArray: [SearchUsers] = []
//
//                    for fireAccount in snapshot.children {
//                        let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
//                        fireAccountArray.append(fireAccount)
//                    }
//
//                    self.filterMateType = fireAccountArray
//
//                    self.tableView.delegate = self
//                    self.tableView.dataSource = self
//                    self.tableView.reloadData()
//                    super.viewDidLoad()
//            })
//        }
//        else {
//            dataRef.reference(withPath: "USERS/").queryOrdered(byChild:"mateType").queryEqual(toValue: mateTypeSearch).observeSingleEvent(of: .value, with:
//                { snapshot in
//
//                    var fireAccountArray: [SearchUsers] = []
//
//                    for fireAccount in snapshot.children {
//                        let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
//                        fireAccountArray.append(fireAccount)
//                    }
//
//                    self.filterMateType = fireAccountArray
//
//                    self.tableView.delegate = self
//                    self.tableView.dataSource = self
//                    self.tableView.reloadData()
//                    super.viewDidLoad()
//            })
//        }
        
        
        ///HERE!! TODO - get users array populated with other arrays.
        users = filterCollege + filterMateType + filterCollege
       
        //this is to text how many values are in each array
        self.testLabel.text = String(filterMateType.count)

        
        //Populate SearchUsersUid Struct (TODO - get pictures to show up based on uidSelf)
//        dataRef.reference(withPath: "USERS").observeSingleEvent(of: .value, with:
//            { snapshot in
//                var fireAccountArrayUid: [SearchUsersUid] = []
//
//                for fireAccountUid in snapshot.children {
//                    let fireAccountUid = SearchUsersUid(snapshot: fireAccountUid as! DataSnapshot)
//                    fireAccountArrayUid.append(fireAccountUid)
//                }
//
//                self.usersUid = fireAccountArrayUid
//
//                self.tableView.delegate = self
//                self.tableView.dataSource = self
//                self.tableView.reloadData()
//        })
        
        //Populate SearchUsersProfilePic Struct
//        let uidSearchImage = dataRef.reference(withPath: "USERS/").value("uidSelf") as? String
//        return uidSearchImage!
        
        let profileImgRef = storageRef.reference().child("imgProfilePictures/\(self.uidSelf!).png")
        profileImgRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Image does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uidSelf!).png")!) as Data?
                    let imagePath = "imgProfilePictures/\(self.uidSelf!).png"
                    
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/png"
                    
                    self.userProfileImage = UIImage(named: "\(self.uidSelf!).png")
                }
            } else {
                self.userProfileImage = UIImage(data: data!)
            }
            
//            var fireAccountArrayProfilePic: [SearchUsersProfilePic] = []
//
//            for fireAccountProfilePic in snapshot.children {
//                let fireAccountProfilePic = SearchUsers(snapshot: fireAccountProfilePic as! DataSnapshot)
//                fireAccountArray.append(fireAccount)
//            }
//
//            self.usersProfilePic = fireAccountArrayProfilePic
//
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            
        }
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
    
        //Display full name
        cell.lblNameSearchList?.text = userinfo.firstName + " " + userinfo.lastName
    
        //Display mateType
        cell.lblMateType?.text = userinfo.mateType
    
        //Display mealPlan
        if userinfo.mealPlan == true {
            cell.lblMealPlan?.text = "M"
        }
        else {
            cell.lblMealPlan?.text = " "
        }
    
        //Display profilePic
        //let imgProfilePicUid = userinfo.uidSelf
        cell.imgProfilePic.image = userProfileImage
        return cell

    }
    
    //awebber - variables to take the values from table and set to a string variable. will use to create a user object and send to details screen
    var firstName:String = " "
    var lastName:String = " "
    var mealPlan:Bool = true
    var college:String = " "
    var mateType:String = " "
    var uid:String = " "
    var imgProfilePic:UIImageView? = nil
    
    //added by awebber to add c
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        firstName = self.users[indexPath.row].firstName
        lastName = self.users[indexPath.row].lastName
        mealPlan = self.users[indexPath.row].mealPlan
        mateType = self.users[indexPath.row].mateType
        uid = self.users[indexPath.row].uid
        
        selectedUser = SearchUsers(firstName: firstName, lastName: lastName,  mealPlan: mealPlan, mateType: mateType, college:college,uid:uid)

        //selectedUserProfilePic = SearchUsersProfilePic(imgProfilePic: imgProfilePic!)
        //selectedUserUid = SearchUsersUid(uid:uid)
        
        var mateTypeSearch:String = filterDataSearch.mateTypeSearch!
        var collegeSearch:String = filterDataSearch.collegeSearch!
        var mealPlanSearch:String = filterDataSearch.mealPlanSearch!
        var clubsOrgsSearch:String = filterDataSearch.clubsOrgsSearch!
        
        filterDataProfile = FilterVCToSearchVCStruct(
            mateTypeSearch:mateTypeSearch,
            collegeSearch:collegeSearch,
            mealPlanSearch:mealPlanSearch,
            clubsOrgsSearch:clubsOrgsSearch
        )
        
        
        performSegue(withIdentifier: "selectedUserDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedUserDetails" {
            let vc = segue.destination as! ProfileViewController
            vc.userDetails = selectedUser
            vc.filterDataProfile = filterDataSearch
        }
    }
}
