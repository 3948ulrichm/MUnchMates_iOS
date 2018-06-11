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
    
    // global variable
    let storageRef = Storage.storage()
    let dataRef = Database.database()
    let cellId = "SearchListTableViewCell"
    let uidSelf = Auth.auth().currentUser?.uid
    var userProfileImage: UIImage?
    var mealPlanAttribute:Bool?
    
    // STRUCTS
    // used to pass to data from search vc back to filter vc and search vc to profile vc
    var filterDataSearch = FilterVCToSearchVCStruct()
    var filterDataProfile = FilterVCToSearchVCStruct()

    // this is the struct used to hold user data that is displayed in search results
    var users: [SearchUsers] = []
    var selectedUser = SearchUsers()
    
    // the structure of our database has an addition node for a user's clubsOrgs, which causes getting club/org data to be a little different than the other "filter by" choices. bc of this, we needed to create an additional struct that is used to pass data between view controllers if the "filter by" is club/org.
    var clubsOrgsArray: [FilterStructClubsOrgs]=[]
    var clubsOrgsArray2 = FilterStructClubsOrgs()

    // viewDidLoad
    override func viewDidLoad() {
        
        // first, we get the entity ("filter by") and attribute (specific filter by value) from the struct that the data was passed to.
        let entitySearch:String = filterDataSearch.entitySearch!
        let attributeSearch:String = filterDataSearch.attributeSearch!
        
        // convert attributeSearch for mealPlan from yes/no to true/false. this will allow use to filter using the mealPlanAttribute value.
        if entitySearch == "meal plan" && attributeSearch == "Yes" {
            self.mealPlanAttribute = true
        }
        else if entitySearch == "meal plan" && attributeSearch == "No" {
            self.mealPlanAttribute = false
        }
        
        //FILTERING...FILTERING...FILTERING...FILTERING...FILTERING...FILTERING!!!
        // if user filtered by club/org, this variable will get the clubsOrgsId. If the user does not filter by club/org, the struct will be empty, this value will remain nil, and it will not be used.
        let clubsOrgsIdRef = clubsOrgsArray2.clubsOrgsId!

        // filter by club/org
        if entitySearch == "club / organization" {
            dataRef.reference(withPath: "USERS/").queryOrdered(byChild:"clubsOrgs/\(clubsOrgsIdRef)/clubsOrgsName").queryEqual(toValue: attributeSearch).observeSingleEvent(of: .value, with:
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
            
        // filter by colleges
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
            
        // filter by mate type
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
            
            
        // filter by meal plan
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
            super.viewDidLoad()
    }
    
    // how many sections does the table view have (this will create mutilple results. for example, if you return 2 and have five results, ten results will show up with with 1st being the same as the 6th, the 2nd being the same as the 7th, etc.)?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // how many rows does the table view have?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return users.count
    }
    
    // pagination. pagination is a method to only load a certain number of cells at a time in order to make them load faster. below the table view functions, there is another function called moreData(). moreData() indicates how many cells we want to load at a time. we chose to load 100 cells at a time, so if a search result is greater than 100, only the first 100 cells will show up. then, when a user scrolls down to the 101st cell, the next 100 cells will load. the idea of the this is to improve the speed of searches loading. in the future, when we have thousands of users and results yield higher returns, we want to make sure results are still loading at a fast speed.
    var data = [1]
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1 {
            moreData()
        }
    }

     // what will display in each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! SearchListTableViewCell
        let userinfo = self.users[indexPath.row]
    
        // MUteMode
        if userinfo.muteMode == true {
            cell.lblMUteMode?.text = "MUteMode"
        }
        else {
            cell.lblMUteMode?.isHidden = true
        }
    
        // full name
        cell.lblNameSearchList?.text = userinfo.firstName + " " + userinfo.lastName
    
        // mateType and college
        cell.lblMateTypeCollege?.text = userinfo.mateType + "  " + userinfo.college
    
        // mealPlan
        if userinfo.mealPlan == true {
            cell.lblMealPlan?.text = "M"
        }
        else {
            cell.lblMealPlan?.text = " "
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
    
    // what happens when you select a cell?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // put all cell data into variables, which we created above this function.
        firstName = self.users[indexPath.row].firstName
        lastName = self.users[indexPath.row].lastName
        mealPlan = self.users[indexPath.row].mealPlan
        mateType = self.users[indexPath.row].mateType
        muteMode = self.users[indexPath.row].muteMode
        uid = self.users[indexPath.row].uid
        
        // put the user info variables into a struct
        selectedUser = SearchUsers(firstName: firstName, lastName: lastName,  mealPlan: mealPlan, mateType: mateType,muteMode:muteMode, college:college,uid:uid)

        // put search criteria into variables to be passes to the profile. these will not be used in a profile, but will be held on to if a user wants to go back to the filter vc, what they searched by will be saved.
        var entitySearch:String = filterDataSearch.entitySearch!
        var attributeSearch:String = filterDataSearch.attributeSearch!
        
        // put search criteria into a struct
        filterDataProfile = FilterVCToSearchVCStruct(
            entitySearch:entitySearch,
            attributeSearch:attributeSearch
        )
        
        // perform segue to go to profile. this segue passes the above two structs to the profile vc.
        performSegue(withIdentifier: "SearchList2Profile", sender: self)
    }
    
    // pagination. pagination is a method to only load a certain number of cells at a time in order to make them load faster. above, there is a table view function that calls moreData(). moreData() indicates how many cells we want to load at a time. we chose to load 100 cells at a time, so if a search result is greater than 100, only the first 100 cells will show up. then, when a user scrolls down to the 101st cell, the next 100 cells will load. the idea of the this is to improve the speed of searches loading. in the future, when we have thousands of users and results yield higher returns, we want to make sure results are still loading at a fast speed.
    func moreData() {
        for _ in 0...100 {
            data.append(data.last! + 1)
        }
        tableView.reloadData()
    }
    
    // ACTION: back button. this is an action bc we need to pass back search criteria data from this vc to the filter vc.
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "SearchList2Filter", sender: self)
    }

    // two segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // SearchList2Profile passes to the user's profile. it passes filter search data for college/mate type/meal plan. there is also a separate struct for club/org searches that gets passed back. while both structs get passed back, the clubs orgs struct will only be used if the entity (filter by) value is club / org. lastly, it passes the details from the user that is selected, however, the only thing that needs to be passed through is the other user's uid. once we have the uid, we can get all of the information we need for their profile.
        if segue.identifier == "SearchList2Profile" {
            let vc = segue.destination as! ProfileViewController
            vc.userDetails = selectedUser
            vc.filterDataProfile = filterDataSearch
            vc.profileClubsOrgsStruct = clubsOrgsArray2
        }
        // SearchList2Filter passes back filter search data for college/mate type/meal plan. there is also a separate struct for club/org searches that gets passed back. while both structs get passed back, the clubs orgs struct will only be used if the entity (filter by) value is club / org.
        if segue.identifier == "SearchList2Filter" {
            let vc = segue.destination as! FilterViewController
            vc.filterData = filterDataSearch
            vc.selectedFilterValueClubsOrgs = clubsOrgsArray2
        }
        
    }
}
