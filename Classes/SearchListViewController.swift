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
    
    let ref = Database.database()
    let cellId = "SearchListCell"
    var users: [SearchUsers] = []
    let uid = Auth.auth().currentUser?.uid
    var selectedUser = SearchUsers()
    
    
    
    
    
    override func viewDidLoad() {
        
        ref.reference(withPath: "USERS/").queryOrdered(byChild:"firstName").observe(.value, with:
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
        cell.lblProfilePic?.image
        
        return cell
        
    }
    
    //awebber - variables to take the values from table and set to a string variable. will use to create a user object and send to details screen
    var firstName:String = ""
    var lastName:String = ""
    var mealPlan:Bool = true
    var mateType:String = ""
    
    //added by awebber to add c
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        firstName = self.users[indexPath.row].firstName
        lastName = self.users[indexPath.row].lastName
        mealPlan = self.users[indexPath.row].mealPlan
        mateType = self.users[indexPath.row].mateType
        
        selectedUser = SearchUsers(firstName: firstName, lastName: lastName,  mealPlan: mealPlan, mateType: mateType)
        performSegue(withIdentifier: "selectedUserDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedUserDetails" {
            let vc = segue.destination as! ProfileViewController
            vc.userDetails = selectedUser
        }
    }
    
}
