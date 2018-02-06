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
    let cellId = "SearchListCell"
    let uid = Auth.auth().currentUser?.uid
    var userProfileImage: UIImage?
    
    //SearchUsers Struct
    var users: [SearchUsers] = []
    var selectedUser = SearchUsers()
    
    //SearchUsersProfilePic Struct
    var usersProfilePic: [SearchUsersProfilePic] = []
    var selectedUserProfilePic = SearchUsersProfilePic()
    
    //SearchUsersUid Struct
    var usersUid: [SearchUsersUid] = []
    var selectedUserUid = SearchUsersUid()
    
    override func viewDidLoad() {
        
        //Populate SearchUsers Struct
        dataRef.reference(withPath: "USERS/").queryOrdered(byChild:"firstName").observeSingleEvent(of: .value, with:
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
        })
        
        //Populate SearchUsersUid Struct (TODO - get pictures to show up based on uid)
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
//        let uidSearchImage = dataRef.reference(withPath: "USERS/").value("uid") as? String
//        return uidSearchImage!
        let profileImgRef = storageRef.reference().child("imgProfilePictures/\(self.uid!).jpg")
        profileImgRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Image does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uid!).jpg")!) as Data?
                    let imagePath = "imgProfilePictures/\(self.uid!).jpg"
                    
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpg"
                    
                    self.userProfileImage = UIImage(named: "\(self.uid!).jpg")
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
        //let imgProfilePicUid = userinfo.uid
        cell.imgProfilePic.image = userProfileImage
        return cell

    }
    
    //awebber - variables to take the values from table and set to a string variable. will use to create a user object and send to details screen
    var firstName:String = " "
    var lastName:String = " "
    var mealPlan:Bool = true
    var mateType:String = " "
    var imgProfilePic:UIImageView? = nil
    
    //added by awebber to add c
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        firstName = self.users[indexPath.row].firstName
        lastName = self.users[indexPath.row].lastName
        mealPlan = self.users[indexPath.row].mealPlan
        mateType = self.users[indexPath.row].mateType
        //imgProfilePic = self.usersProfilePic[indexPath.row].imgProfilePic
        //searchUid = self.usersUid[indexPath.row].searchUid
        
        selectedUser = SearchUsers(firstName: firstName, lastName: lastName,  mealPlan: mealPlan, mateType: mateType)
        //selectedUserProfilePic = SearchUsersProfilePic(imgProfilePic: imgProfilePic!)
        //selectedUserUid = SearchUsersUid(searchUid:searchUid)
        
        performSegue(withIdentifier: "selectedUserDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedUserDetails" {
            let vc = segue.destination as! ProfileViewController
            vc.userDetails = selectedUser
        }
    }
}
