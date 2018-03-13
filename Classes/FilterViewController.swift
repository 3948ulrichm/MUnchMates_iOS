//
//  FilterViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 10/18/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: global variables
    var filterEntityBool = false
    var mateTypeBool = false
    var collegeBool = false
    var mealPlanBool = false
    var clubsOrgsBool = false
    var countrows: Int?
    
    
    let ref = Database.database()
    let cellId = "FilterButtonName"
    
    //filter details - used to pass information to search so user can keep filter when going back
    var filter: [FilterVCToSearchVCStruct] = []
    var filterData = FilterVCToSearchVCStruct()
    
    //mateType
    var mateTypeStruct: [FilterStructMateType] = []
    var selectedFilterValueMateType = FilterStructMateType()
    
    //college
    var collegeStruct: [FilterStructCollege] = []
    var selectedFilterValueCollege = FilterStructCollege()
    
    //mealPlan
    var mealPlanStruct: [FilterStructMealPlan] = []
    var selectedFilterValueMealPlan = FilterStructMealPlan()
    
    //clubsOrgs
    var clubsOrgsStruct: [FilterStructClubsOrgs] = []
    var selectedFilterValueClubsOrgs = FilterStructClubsOrgs()
    
    //FilterStructEntity
    var entityStruct: [FilterStructEntity] = []
    var selectedFilterValueEntity = FilterStructEntity()

    //MARK: IBOutlets
    @IBOutlet weak var btnFilterEntity: UIButton!
    @IBOutlet weak var btnFilterAttribute: UIButton!
    @IBOutlet weak var viewPickerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblWhatAttribute: UILabel!
    @IBOutlet weak var btnSelectAllOutlet: UIButton!
    

    //MARK: viewDidLoad
    override func viewDidLoad() {
        var entitySearchLoad = filterData.entitySearch!
        var attributeSearchLoad = filterData.attributeSearch!
        var entitySearchPlaceholder = "club / organization"
        var attributeSearchPlaceholder = "all"
        
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
        
        
        viewPickerView.isHidden = true
        super.viewDidLoad()
    }

    // MARK: IBActions
    @IBAction func btnSearch(_ sender: Any) {

        
        var entitySearch:String = self.btnFilterEntity.currentTitle!
        var attributeSearch:String = self.btnFilterAttribute.currentTitle!

                filterData = FilterVCToSearchVCStruct(
                    entitySearch:entitySearch,
                    attributeSearch:attributeSearch
                )

        performSegue(withIdentifier: "FilterToSearchList", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterToSearchList" {
            let vc = segue.destination as! SearchListViewController
            vc.filterDataSearch = filterData
            vc.clubsOrgsArray2 = selectedFilterValueClubsOrgs
        }
    }
    
    //entity filter button clicked
    @IBAction func btnFilterEntityClicked(_ sender: Any) {
        
        btnSelectAllOutlet.isUserInteractionEnabled = false
        btnSelectAllOutlet.isHidden = true
        
        filterEntityBool = true
        mateTypeBool = false
        collegeBool = false
        mealPlanBool = false
        clubsOrgsBool = false
        
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
        
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
    
    @IBAction func btnFilterAttributeClicked(_ sender: Any) {
        
        btnSelectAllOutlet.isUserInteractionEnabled = true
        btnSelectAllOutlet.isHidden = false
        
        if btnFilterEntity.currentTitle == "mate type" {
        filterEntityBool = false
        mateTypeBool = true
        collegeBool = false
        mealPlanBool = false
        clubsOrgsBool = false
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
        
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
    
    
    if btnFilterEntity.currentTitle == "college" {
        filterEntityBool = false
        mateTypeBool = false
        collegeBool = true
        mealPlanBool = false
        clubsOrgsBool = false
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
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
    
    if btnFilterEntity.currentTitle == "meal plan" {
        filterEntityBool = false
        mateTypeBool = false
        collegeBool = false
        mealPlanBool = true
        clubsOrgsBool = false
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
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
    
    if btnFilterEntity.currentTitle == "club / organization" {
        filterEntityBool = false
        mateTypeBool = false
        collegeBool = false
        mealPlanBool = false
        clubsOrgsBool = true
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
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
    
    //select picker view value, send to selected button
    @IBAction func btnCancel(_ sender: Any) {
        viewPickerView.isHidden = true
        filterEntityBool = false
        mateTypeBool = false
        collegeBool = false
        mealPlanBool = false
        clubsOrgsBool = false
    }
    
    @IBAction func btnSelectAll(_ sender: Any) {
        
        if mateTypeBool == true ||
            collegeBool == true ||
            mealPlanBool == true ||
            clubsOrgsBool == true
            {
            btnFilterAttribute.setTitle("all", for: .normal)
            viewPickerView.isHidden = true
        }
        else if filterEntityBool == true {
            btnFilterEntity.setTitle("all", for: .normal)
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
    

    //sign out
    @IBAction func btnSignOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(vc!, animated: true, completion: nil)
        
        
    }
    
    //TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows
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
    
    //What is in each cell?
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

    //What happens if you select a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filterEntityBool == true {
            filterEntityName = self.entityStruct[indexPath.row].filterEntityName!
            selectedFilterValueEntity = FilterStructEntity(filterEntityName:filterEntityName)
            //if a new entity is selected, change the name of the attribute btn to "all"
                if filterEntityName != btnFilterEntity.currentTitle! {
                    btnFilterAttribute.setTitle("all", for: .normal)
                }
            btnFilterEntity.setTitle(filterEntityName, for: .normal)
            //change label to reflect entity selected
                var btnFilterEntityCurrentTitle = btnFilterEntity.currentTitle!
                if btnFilterEntityCurrentTitle == "meal plan" {
                    lblWhatAttribute.text = "Does your mate have a \(btnFilterEntityCurrentTitle)?"
                }
                else {
                    lblWhatAttribute.text = "What \(btnFilterEntityCurrentTitle)?"
                }
            viewPickerView.isHidden = true
            filterEntityBool = false
        }
        else if mateTypeBool == true {
            mateTypeName = self.mateTypeStruct[indexPath.row].mateTypeName!
            selectedFilterValueMateType = FilterStructMateType(mateTypeName:mateTypeName)
            btnFilterAttribute.setTitle(mateTypeName, for: .normal)
            viewPickerView.isHidden = true
            mateTypeBool = false
        }
        else if collegeBool == true {
            collegeName = self.collegeStruct[indexPath.row].collegeName!
            selectedFilterValueCollege = FilterStructCollege(collegeName:collegeName)
            btnFilterAttribute.setTitle(collegeName, for: .normal)
            viewPickerView.isHidden = true
            collegeBool = false
        }
        else if mealPlanBool == true {
            mealPlanName = self.mealPlanStruct[indexPath.row].mealPlanName!
            selectedFilterValueMealPlan = FilterStructMealPlan(mealPlanName:mealPlanName)
            btnFilterAttribute.setTitle(mealPlanName, for: .normal)
            viewPickerView.isHidden = true
            mealPlanBool = false
        }
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


/* pickerView notes
1. create global variables (Booleans, start as false) for each item to be filtered (mateType, College, etc.)
2. create ibactions for each button
3. within the ibaction, change respective booleans from false to true
4. In pickerView, populate with array that has true boolean associated with it

 */


