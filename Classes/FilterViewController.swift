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
    var mateTypeBool = false
    var collegeBool = false
    var mealPlanBool = false
    var clubsOrgsBool = false
    var countrows: Int?
    
    
    let ref = Database.database()
    let cellId = "FilterButtonName"
    
    //filter details
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
    
    
    
//    var titleRow: String?

    //MARK: IBOutlets
    @IBOutlet weak var btnMateTypePV: UIButton!
    @IBOutlet weak var btnCollegePV: UIButton!
    @IBOutlet weak var btnMealPlanPV: UIButton!
    @IBOutlet weak var btnClubsOrgsPV: UIButton!
    @IBOutlet weak var viewPickerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    

    //MARK: viewDidLoad
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        

        //Test to see if currentTitle method works --> it does!
//        btnMateTypePV.setTitle("mateTypeName", for: .normal)
//        var collegeSearch: String = self.btnMateTypePV.currentTitle!
//        btnCollegePV.setTitle(collegeSearch, for: .normal)

        viewPickerView.isHidden = true
        super.viewDidLoad()
    }

    // MARK: IBActions
   
//    var mateTypeSearch:String = "Freshman"
//    var collegeSearch:String = "self.btnCollegePV.currentTitle!"
//    var mealPlanSearch:String = "self.btnMealPlanPV.currentTitle!"
//    var clubsOrgsSearch:String = "self.btnClubsOrgsPV.currentTitle!"
    
    
    @IBAction func btnSearch(_ sender: Any) {
        
        var mateTypeSearch:String = self.btnMateTypePV.currentTitle!
        var collegeSearch:String = self.btnCollegePV.currentTitle!
        var mealPlanSearch:String = self.btnMealPlanPV.currentTitle!
        var clubsOrgsSearch:String = self.btnClubsOrgsPV.currentTitle!
        
        filterData = FilterVCToSearchVCStruct(
            mateTypeSearch:mateTypeSearch,
            collegeSearch:collegeSearch,
            mealPlanSearch:mealPlanSearch,
            clubsOrgsSearch:clubsOrgsSearch
        )
        
        self.testLabel.text = filterData.mateTypeSearch
        
        performSegue(withIdentifier: "FilterToSearchList", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterToSearchList" {
            let vc = segue.destination as! SearchListViewController
            vc.filterDataSearch = filterData
        }
    }
    
    @IBAction func btnMateTypePVAction(_ sender: Any) {
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
    
    @IBAction func btnCollegePVAction(_ sender: Any) {
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
    
    @IBAction func btnMealPlanPVAction(_ sender: Any) {
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
    
    @IBAction func btnClubsOrgsPVAction(_ sender: Any) {
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
    
    //select picker view value, send to selected button
    @IBAction func btnCancel(_ sender: Any) {
        viewPickerView.isHidden = true
        mateTypeBool = false
        collegeBool = false
        mealPlanBool = false
        clubsOrgsBool = false
    }
    
    @IBAction func btnSelectAll(_ sender: Any) {
        
        if mateTypeBool == true {
            btnMateTypePV.setTitle("All", for: .normal)
            viewPickerView.isHidden = true
        }
        else if collegeBool == true {
            btnCollegePV.setTitle("All", for: .normal)
            viewPickerView.isHidden = true
        }
        else if mealPlanBool == true {
            btnMealPlanPV.setTitle("All", for: .normal)
            viewPickerView.isHidden = true
        }
        else if clubsOrgsBool == true {
            btnClubsOrgsPV.setTitle("All", for: .normal)
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
        if mateTypeBool == true {
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
        }        else {
            return 0
        }
    }
    
    //What is in each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! FilterTableViewCell
        if mateTypeBool == true {
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
            let clubsOrg = self.clubsOrgsStruct[indexPath.row]
            cell.lblFilterButtonName?.text = clubsOrg.clubsOrgsName
        }
        
        return cell
        
    }
    
    var mateTypeName:String = " "
    var collegeName:String = " "
    var mealPlanName:String = " "
    var clubsOrgsName:String = " "

    //What happens if you select a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mateTypeBool == true {
            mateTypeName = self.mateTypeStruct[indexPath.row].mateTypeName!
            selectedFilterValueMateType = FilterStructMateType(mateTypeName:mateTypeName)
            btnMateTypePV.setTitle(mateTypeName, for: .normal)
            viewPickerView.isHidden = true
            mateTypeBool = false
        }
        else if collegeBool == true {
            collegeName = self.collegeStruct[indexPath.row].collegeName!
            selectedFilterValueCollege = FilterStructCollege(collegeName:collegeName)
            btnCollegePV.setTitle(collegeName, for: .normal)
            viewPickerView.isHidden = true
            collegeBool = false
        }
        else if mealPlanBool == true {
            mealPlanName = self.mealPlanStruct[indexPath.row].mealPlanName!
            selectedFilterValueMealPlan = FilterStructMealPlan(mealPlanName:mealPlanName)
            btnMealPlanPV.setTitle(mealPlanName, for: .normal)
            viewPickerView.isHidden = true
            mealPlanBool = false
        }
        else if clubsOrgsBool == true {
            clubsOrgsName = self.clubsOrgsStruct[indexPath.row].clubsOrgsName!
            selectedFilterValueClubsOrgs = FilterStructClubsOrgs(clubsOrgsName:clubsOrgsName)
            btnClubsOrgsPV.setTitle(clubsOrgsName, for: .normal)
            viewPickerView.isHidden = true
            mealPlanBool = false
        }
    }
}


/* pickerView notes
1. create global variables (Booleans, start as false) for each item to be filtered (mateType, College, etc.)
2. create ibactions for each button
3. within the ibaction, change respective booleans from false to true
4. In pickerView, populate with array that has true boolean associated with it

 */


