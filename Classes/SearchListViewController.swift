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
    
    
//filterMateType...filterMateType...filterMateType...filterMateType
        if mateTypeSearch == "All" {
        dataRef.reference(withPath: "USERS/").queryOrdered(byChild:"firstName").observeSingleEvent(of: .value, with:
            { snapshot in
                var fireAccountArray: [SearchUsers] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                    
                    //let clubsOrgsNames = fireAccount.map(){$0.clubsOrgsName}
                    
                    fireAccountArray.append(fireAccount)
                    
                }
                
                //TEMP
//                self.filterMateType = fireAccountArray
                self.users = fireAccountArray
                
                var testLabelString = self.users.count
                self.testLabel.text = "\(String(testLabelString)) Results"

                
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
                    
                    self.users = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    super.viewDidLoad()
                })
        }
        
       
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
    var uid:String = " "
    //var imgProfilePic:UIImageView? = nil
    
    //what happens when you select a cell
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
        
        
        performSegue(withIdentifier: "SearchList2Profile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchList2Profile" {
            let vc = segue.destination as! ProfileViewController
            vc.userDetails = selectedUser
            vc.filterDataProfile = filterDataSearch
        }
    }
}
