//
//  FilterViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 10/18/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    // global variables
    var filterEntityBool = false
    var mateTypeBool = false
    var collegeBool = false
    var mealPlanBool = false
    var clubsOrgsBool = false
    var countrows: Int?
    var uid = Auth.auth().currentUser?.uid
    var dataRef = Database.database()
    let ref = Database.database()
    let cellId = "FilterButtonName"
    
    // STRUCTS
    // filter details - used to pass information to search so user can keep filter when going back
    var filter: [FilterVCToSearchVCStruct] = []
    var filterData = FilterVCToSearchVCStruct()
    
    // mateType. used to display list of mateTypes in table view if mateType is selected as what the user will filter by.
    var mateTypeStruct: [FilterStructMateType] = []
    var selectedFilterValueMateType = FilterStructMateType()
    
    // college. used to display list of colleges in table view if college is selected as what the user will filter by.
    var collegeStruct: [FilterStructCollege] = []
    var selectedFilterValueCollege = FilterStructCollege()
    
    // mealPlan. used to display list of mealPlans in table view if mealPlan is selected as what the user will filter by.
    var mealPlanStruct: [FilterStructMealPlan] = []
    var selectedFilterValueMealPlan = FilterStructMealPlan()
    
    // clubsOrgs. used to display list of clubsOrgs in table view if clubsOrgs is selected as what the user will filter by.
    var clubsOrgsStruct: [FilterStructClubsOrgs] = []
    var selectedFilterValueClubsOrgs = FilterStructClubsOrgs()
    
    // FilterStructEntity. this is the struct that will list "mate type", "college", etc. in the table view for what a user can filter by.
    var entityStruct: [FilterStructEntity] = []
    var selectedFilterValueEntity = FilterStructEntity()
    
    // unread message struct. this counts unread messages and displays the number on the messages button. the messages button ussually says "messages", however, if there are unread messages it will also show a number following "messages". i.e. one unread message will diplay "messages (1)". the below struct gets the number 1 in this example.
    var countUnreadMessagesFilter: [UserInConversations] = []

    // outlets
    @IBOutlet weak var btnFilterEntity: UIButton!
    @IBOutlet weak var btnFilterAttribute: UIButton!
    @IBOutlet weak var viewPickerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblWhatAttribute: UILabel!
    @IBOutlet weak var btnSelectAllOutlet: UIButton!
    @IBOutlet weak var btnMessages: UIButton!
    
    
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        // searches for how many unread messages a user has. "Constants" below calls "Constants.swift" in the "Models" folder. This is a file Andrew made to reference "Database.database().reference()". I thought about changing this to "Database.database().reference()" and deleting the Constants file, but I am not sure if he used it in other parts of the code, so I am just going to leave it!
        Constants.refs.databaseRoot.child("USERS/\(self.uid!)/conversations/senderList/").queryOrdered(byChild:"read").queryEqual(toValue: false).observe(.value, with:
            { snapshot in
                var fireAccountArray: [UserInConversations] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = UserInConversations(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                }
                
                self.countUnreadMessagesFilter = fireAccountArray
                
                // puts count of unread messages into let
                let unreadMessageCount:Int = self.countUnreadMessagesFilter.count
                
                // if count of unread messages is greater than 0, the title of the messages button is changed from "Messages" to "Messages (#)"
                if unreadMessageCount > 0 {
                    self.btnMessages.setTitle("Messages (\(unreadMessageCount))", for: .normal)
                }
                else {
                    self.btnMessages.setTitle("Messages", for: .normal)
                }
        })
    }

    // viewDidLoad. idk why I had some code in viewWillAppear and some in viewDidLoad. it does not matter where the code is, both functions essentially do the same thing.
    override func viewDidLoad() {
        // every time a user opens the app and goes to FilterViewController, a variable named "lastOpened" is updated. this variable is a time stamp to let us know the last time a user opened the app. this will allow us to see if their are inactive users in our database.
        // gather variables needed to produce timestamp
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from:date)
        let minute = calendar.component(.minute, from:date)
        let second = calendar.component(.second, from:date)

        let month = calendar.component(.month, from:date)
        let day = calendar.component(.day, from:date)
        let year = calendar.component(.year, from:date)
        
        // create "lastOpened" timestamp
        let lastOpened = "\(month).\(day).\(year) • \(hour):\(minute):\(second)"
        
        // set value in database with updated "lastOpened" variable
        dataRef.reference().child("USERS/\(uid!)/lastOpened").setValue(lastOpened)
        
        // every time a user opens the app and goes to FilterViewController, a variable named "searchOrderNumber" is updated. this variable produces a random number from 1 to 100000. the original idea of this was to use it to sort users when searching "all" users in the database, which is a recently removed feature. bc we didn't want the same users coming up at the top of the results each search, we incorporated this random number generator to help randomize how users are sorted. now that a user must select a specific "club / org", "college", etc. when filtering, this number has no purpose at the moment, but still gets updated when a user opens the app and goes to FilterViewController.
        let searchOrderNumber = Int(arc4random_uniform(UInt32(100000)))
        dataRef.reference().child("USERS/\(uid!)/searchOrderNumber").setValue(searchOrderNumber)
        
        // load buttons and labels. if a search has been made and the user selected "back", entitySearchLoad and attributeSearchLoad are load the titles of the buttons. Otherwise, entitySearchPlaceholder and attributeSearchPlaceholder are used.
        let entitySearchLoad = filterData.entitySearch!
        let attributeSearchLoad = filterData.attributeSearch!
        let entitySearchPlaceholder = "club / organization"
        let attributeSearchPlaceholder = "(select)"
        
        // if entitySearchLoad and attributeSearchLoad are blank, it means the struct they are pulling from is blank, meaning that there is no saved search. in this case, entitySearchPlaceholder and attributeSearchPlaceholder will populate the buttons. otherwise, recent search would be saved and would load when a user goes back to the filter vc.
        if entitySearchLoad != "" && attributeSearchLoad != "" {
            self.btnFilterEntity.setTitle(entitySearchLoad, for: .normal)
            self.btnFilterAttribute.setTitle(attributeSearchLoad, for: .normal)
            self.lblWhatAttribute.text = "What \(entitySearchLoad)?"
        }
        else {
            self.btnFilterEntity.setTitle(entitySearchPlaceholder, for: .normal)
            self.btnFilterAttribute.setTitle(attributeSearchPlaceholder, for: .normal)
            self.lblWhatAttribute.text = "What \(entitySearchPlaceholder)?"
        }
        
        // viewPickerView is the name of the view with the table view in it. orginally, we were going to use a picker view, but we decided a table view was better. we had already named the view "viewPickerView" and never changed it, but this is refering to a table view NOT a picker view.
        // viewPickerView starts hiddens
        viewPickerView.isHidden = true
        
        super.viewDidLoad()
    }

    // ACTION: search button. when searching, the app uses the titles of the buttons as the search criteria. btnFilterEntity is "club / org" , "college", etc. btnFilterAttribute is the specific "club / org", "college", etc. the search uses the combination of the two titles to filter the database and produce results for the user.
    @IBAction func btnSearch(_ sender: Any) {
        var entitySearch:String = self.btnFilterEntity.currentTitle!
        var attributeSearch:String = self.btnFilterAttribute.currentTitle!
        
        // the CHECKs if the button title for btnFilterAttribute is "(select)". if so, this means the user did not pick a specific attribute. if this occurs, an alert will appear telling the user that they need to pick a specific "club / org", "college", etc.
        if attributeSearch == "(select)" {
            let alertController = UIAlertController(title: "Please select a specific \(entitySearch)", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Aye aye!", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
            
        // if the user picked a specific attribute, the app will put the button titles into a struct, which will get passed to "SearchListViewController" for to filter the table view in that vc.
        else {
                filterData = FilterVCToSearchVCStruct(
                    entitySearch:entitySearch,
                    attributeSearch:attributeSearch
                )
        performSegue(withIdentifier: "FilterToSearchList", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterToSearchList" {
            let vc = segue.destination as! SearchListViewController
            vc.filterDataSearch = filterData
            vc.clubsOrgsArray2 = selectedFilterValueClubsOrgs
        }
    }
    
    // entity ("club / org", "college", etc.) filter button clicked
    @IBAction func btnFilterEntityClicked(_ sender: Any) {
        
        // btnSelectAllOutlet has been changed from "select all" to "clear selection" bc the app no longer lets users search all other users in the database. this is a bar button that appears at the top of the view that appears when a the attribute or entity buttons have been selected.
        btnSelectAllOutlet.isUserInteractionEnabled = false
        btnSelectAllOutlet.isHidden = true
        
        // bc btnFilterEntity has been selected, that bool will display as true. this is used to know what LISTS node to pull from in the Firebase Database. in this case, we will pull from "filterEntities"
        filterEntityBool = true
        mateTypeBool = false
        collegeBool = false
        mealPlanBool = false
        clubsOrgsBool = false
        
        // check to ensure viewPickerView starts as hidden
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
        
        // bc filterEntityBool is true, the list that will display in the table view is from the filterEntities node under LISTS in the Firebase Database.
        if filterEntityBool == true {
            ref.reference(withPath: "LISTS/filterEntities").queryOrdered(byChild:"filterEntityName").observe(.value, with:
                { snapshot in
                    
                    var fireAccountArray: [FilterStructEntity] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = FilterStructEntity(snapshot: fireAccount as! DataSnapshot)
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.entityStruct = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
            })
        }
    }
    
    // attribute ("big brothers big sisters", "college of business administration", etc.) filter button clicked
    @IBAction func btnFilterAttributeClicked(_ sender: Any) {
        
        // btnSelectAllOutlet has been changed from "select all" to "clear selection" bc the app no longer lets users search all other users in the database. this is a bar button that appears at the top of the view that appears when a the attribute or entity buttons have been selected.
        btnSelectAllOutlet.isUserInteractionEnabled = true
        btnSelectAllOutlet.isHidden = false
        
        // checks btnFilterEntity title. based on that, code makes matching bool true, and the others false.
        if btnFilterEntity.currentTitle == "mate type" {
            filterEntityBool = false
            mateTypeBool = true
            collegeBool = false
            mealPlanBool = false
            clubsOrgsBool = false
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
        
        // based on true bool, code pulls list from Firebase Database
        if mateTypeBool == true
        {
            ref.reference(withPath: "LISTS/mateTypes").queryOrdered(byChild:"mateTypeId").observe(.value, with:
                { snapshot in
                    
                    var fireAccountArray: [FilterStructMateType] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = FilterStructMateType(snapshot: fireAccount as! DataSnapshot)
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.mateTypeStruct = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
            })
        }
    }
    
        // checks btnFilterEntity title. based on that, code makes matching bool true, and the others false.
        if btnFilterEntity.currentTitle == "college" {
            filterEntityBool = false
            mateTypeBool = false
            collegeBool = true
            mealPlanBool = false
            clubsOrgsBool = false
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
            
        // based on true bool, code pulls list from Firebase Database
        if collegeBool == true
        {
            ref.reference(withPath: "LISTS/colleges").queryOrdered(byChild:"collegeName").observe(.value, with:
                { snapshot in
                    
                    var fireAccountArray: [FilterStructCollege] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = FilterStructCollege(snapshot: fireAccount as! DataSnapshot)
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.collegeStruct = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
            })
        }
    }
        
        // checks btnFilterEntity title. based on that, code makes matching bool true, and the others false.
        if btnFilterEntity.currentTitle == "meal plan" {
            filterEntityBool = false
            mateTypeBool = false
            collegeBool = false
            mealPlanBool = true
            clubsOrgsBool = false
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
            
        // based on true bool, code pulls list from Firebase Database
        if mealPlanBool == true
        {
            ref.reference(withPath: "LISTS/mealPlan").queryOrdered(byChild:"mealPlanId").observe(.value, with:
                { snapshot in
                    
                    var fireAccountArray: [FilterStructMealPlan] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = FilterStructMealPlan(snapshot: fireAccount as! DataSnapshot)
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.mealPlanStruct = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
            })
        }
    }
        
        // checks btnFilterEntity title. based on that, code makes matching bool true, and the others false.
        if btnFilterEntity.currentTitle == "club / organization" {
            filterEntityBool = false
            mateTypeBool = false
            collegeBool = false
            mealPlanBool = false
            clubsOrgsBool = true
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
        
        // based on true bool, code pulls list from Firebase Database
        if clubsOrgsBool == true
        {
            ref.reference(withPath: "LISTS/clubsOrgs").queryOrdered(byChild:"clubsOrgsName").observe(.value, with:
                { snapshot in
                    
                    var fireAccountArray: [FilterStructClubsOrgs] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = FilterStructClubsOrgs(snapshot: fireAccount as! DataSnapshot)
                        fireAccountArray.append(fireAccount)
                    }
                    
                    self.clubsOrgsStruct = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    // ACTION: cancel button on top bar of viewPickerView. if cancel is pressed, all bools change to false and viewPickerView is hidden.
    @IBAction func btnCancel(_ sender: Any) {
        viewPickerView.isHidden = true
        filterEntityBool = false
        mateTypeBool = false
        collegeBool = false
        mealPlanBool = false
        clubsOrgsBool = false
    }
    
    // ACTION: "select all" button on the top bar of viewPickerView has been changed to "clear selection" bc the app no longer lets users search all other users in the database. this is a bar button that appears at the top of the view that appears when a the attribute or entity buttons have been selected. bc of this when btnSelectAll (which has the title "clear selection") is pressed, the title of btnFilterAttribute changes back to "(select)"

    @IBAction func btnSelectAll(_ sender: Any) {
        if mateTypeBool == true ||
            collegeBool == true ||
            mealPlanBool == true ||
            clubsOrgsBool == true
            {
            btnFilterAttribute.setTitle("(select)", for: .normal)
            viewPickerView.isHidden = true
        }
        else if filterEntityBool == true {
            btnFilterEntity.setTitle("(select)", for: .normal)
            viewPickerView.isHidden = true
        }
        else {
            viewPickerView.isHidden = true
            mateTypeBool = false
            collegeBool = false
            mealPlanBool = false
            clubsOrgsBool = false
        }
    }
    
    // ACTION: logout button
    @IBAction func btnSignOut(_ sender: UIBarButtonItem) {
      
        // ALERT: pop up message asking user if they are sure they want to logout
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        // delete btn in alert (variable)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive,
            handler: { action in
                do {
                    try Auth.auth().signOut()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                self.present(vc!, animated: true, completion: nil)
        })
        // cancel btn in alert (variable)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        { (result: UIAlertAction) -> Void in
        }
        // create buttons using varibles above
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    // TABLE VIEW
    // how many sections of table view (this will create mutilple results. for example, if you return 2 and have five results, ten results will show up with with 1st being the same as the 6th, the 2nd being the same as the 7th, etc.)?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // how many rows?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filterEntityBool == true {
            return entityStruct.count
        }
        else if mateTypeBool == true {
            return mateTypeStruct.count
        }
        else if collegeBool == true {
            return collegeStruct.count
        }
        else if mealPlanBool == true {
            return mealPlanStruct.count
        }
        else if clubsOrgsBool == true {
            return clubsOrgsStruct.count
        }
        else {
            return 0
        }
    }
    
    // what is in each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! FilterTableViewCell
       if filterEntityBool == true {
            let entity = self.entityStruct[indexPath.row]
            cell.lblFilterButtonName?.text = entity.filterEntityName
        }
        else if mateTypeBool == true {
            let mateType = self.mateTypeStruct[indexPath.row]
            cell.lblFilterButtonName?.text = mateType.mateTypeName
        }
        else if collegeBool == true {
            let college = self.collegeStruct[indexPath.row]
            cell.lblFilterButtonName?.text = college.collegeName
        }
        else if mealPlanBool == true {
            let mealPlan = self.mealPlanStruct[indexPath.row]
            cell.lblFilterButtonName?.text = mealPlan.mealPlanName
        }
        else if clubsOrgsBool == true {
            let clubsOrgsName = self.clubsOrgsStruct[indexPath.row].clubsOrgsName
            // while clubsOrgsId is not displayed, clubsOrgsId is still needed, so it is saved as a let and passed through to SearchListViewController when search button is pressed.
            let clubsOrgsId = self.clubsOrgsStruct[indexPath.row].clubsOrgsId
            cell.lblFilterButtonName?.text = clubsOrgsName
        }
        return cell
    }
    
    var filterEntityName:String = " "
    var mateTypeName:String = " "
    var collegeName:String = " "
    var mealPlanName:String = " "
    var clubsOrgsName:String = " "
    var clubsOrgsId:String = " "

    // what happens if you select a row?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filterEntityBool == true {
            filterEntityName = self.entityStruct[indexPath.row].filterEntityName!
            selectedFilterValueEntity = FilterStructEntity(filterEntityName:filterEntityName)
            
            // if a new entity is selected, change the name of the attribute btn to "(select)"
                if filterEntityName != btnFilterEntity.currentTitle! {
                    btnFilterAttribute.setTitle("(select)", for: .normal)
                }
            
            // set title of btnFilterEntity with label of selected cell in table view
            btnFilterEntity.setTitle(filterEntityName, for: .normal)
            
            // change label to reflect entity selected
            var btnFilterEntityCurrentTitle = btnFilterEntity.currentTitle!
            if btnFilterEntityCurrentTitle == "meal plan" {
                lblWhatAttribute.text = "Does your mate have a \(btnFilterEntityCurrentTitle)?"
            }
            else {
                lblWhatAttribute.text = "What \(btnFilterEntityCurrentTitle)?"
            }
            
            // when cell is selected, hide viewPickerView.
            // viewPickerView is the name of the view with the table view in it. orginally, we were going to use a picker view, but we decided a table view was better. we had already named the view "viewPickerView" and never changed it, but this is refering to a table view NOT a picker view.
            viewPickerView.isHidden = true
            filterEntityBool = false
        }
            
        // when mateTypeBool is true, it means that the user has selected the attribute button and mateType is the entity that will be filtered by. bc of this, mateTypes will be listed in the table view and the one selected will be the new title of the attribute button.
        else if mateTypeBool == true {
            mateTypeName = self.mateTypeStruct[indexPath.row].mateTypeName!
            selectedFilterValueMateType = FilterStructMateType(mateTypeName:mateTypeName)
            btnFilterAttribute.setTitle(mateTypeName, for: .normal)
            viewPickerView.isHidden = true
            mateTypeBool = false
        }
            
        // when collegeBool is true, it means that the user has selected the attribute button and college is the entity that will be filtered by. bc of this, colleges will be listed in the table view and the one selected will be the new title of the attribute button.
        else if collegeBool == true {
            collegeName = self.collegeStruct[indexPath.row].collegeName!
            selectedFilterValueCollege = FilterStructCollege(collegeName:collegeName)
            btnFilterAttribute.setTitle(collegeName, for: .normal)
            viewPickerView.isHidden = true
            collegeBool = false
        }
            
        // when mealPlanBool is true, it means that the user has selected the attribute button and mealPlan is the entity that will be filtered by. bc of this, mealPlans (yes or no) will be listed in the table view and the one selected will be the new title of the attribute button.
        else if mealPlanBool == true {
            mealPlanName = self.mealPlanStruct[indexPath.row].mealPlanName!
            selectedFilterValueMealPlan = FilterStructMealPlan(mealPlanName:mealPlanName)
            btnFilterAttribute.setTitle(mealPlanName, for: .normal)
            viewPickerView.isHidden = true
            mealPlanBool = false
        }
            
        // when clubsOrgsBool is true, it means that the user has selected the attribute button and clubsOrgs is the entity that will be filtered by. bc of this, clubsOrgs will be listed in the table view and the one selected will be the new title of the attribute button.
        else if clubsOrgsBool == true {
            clubsOrgsName = self.clubsOrgsStruct[indexPath.row].clubsOrgsName!
            clubsOrgsId = self.clubsOrgsStruct[indexPath.row].clubsOrgsId!
            selectedFilterValueClubsOrgs = FilterStructClubsOrgs(
                clubsOrgsName:clubsOrgsName,
                clubsOrgsId:clubsOrgsId
            )
            btnFilterAttribute.setTitle(clubsOrgsName, for: .normal)
            viewPickerView.isHidden = true
            clubsOrgsBool = false
        }
    }
}
