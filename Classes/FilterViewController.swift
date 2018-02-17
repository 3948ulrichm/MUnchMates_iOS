//
//  FilterViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 10/18/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class FilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: global variables
    var mateTypeBool = false
    var collegeBool = false
    var mealPlanBool = false
    var clubsOrgsBool = false
    var countrows: Int?
//    var titleRow: String?

    //MARK: IBOutlets
    @IBOutlet weak var btnMateTypePV: UIButton!
    @IBOutlet weak var btnCollegePV: UIButton!
    @IBOutlet weak var btnMealPlanPV: UIButton!
    @IBOutlet weak var btnClubsOrgsPV: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var viewPickerView: UIView!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {

        viewPickerView.isHidden = true
        
        pickerView.delegate = self
        pickerView.dataSource = self

        super.viewDidLoad()
    }

    // MARK: IBActions
    
    @IBAction func btnSearch(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchListViewController")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func btnMateTypePVAction(_ sender: Any) {
        if mateTypeBool == false {
            mateTypeBool = true
        }
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
    }
    
    @IBAction func btnCollegePVAction(_ sender: Any) {
        if collegeBool == false {
            collegeBool = true
        }
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
    }
    
    @IBAction func btnMealPlanPVAction(_ sender: Any) {
        if mealPlanBool == false {
            mealPlanBool = true
        }
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
    }
    
    @IBAction func btnClubsOrgsPVAction(_ sender: Any) {
        if clubsOrgsBool == false {
            clubsOrgsBool = true
        }
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
    }
    
    
    // MARK: Arrays
    var mateTypes = [
        "All",
        "Freshman",
        "Sophomore",
        "Junior",
        "Senior",
        "Graduate Student",
        "Professor",
        "Administrator",
        "Jesuit",
        "Other"
    ]
    
    var colleges = [
        "All",
        "College of Arts and Sciences",
        "College of Business",
        "College of Communication",
        "College of Education",
        "College of Engineering",
        "College of Health Sciences",
        "College of Nursing",
        "College of __",
        "College of __"
    ]
    
    var mealPlans = [
        "All",
        "Yes",
        "No",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " "
    ]
    
    var clubsOrgs = [
        "All",
        "Kappa Squidma",
        "Delta Chi",
        "Advertising Club",
        "Alpha Epsilon Delta",
        "Alpha Eta Mu Beta",
        "Alpha Sigma Nu",
        "American Medical Student Association",
        "BBBS",
        "Midnight Run"
    ]
    

    //picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }

    func pickerView(_ pickerView:UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        var countrows : Int? = 10
//        if collegeBool == true {
//            countrows = colleges.count
//        }
//        if mateTypeBool == true {
//            countrows! = mateTypes.count
//        }
//        else if mealPlanBool == true {
//            countrows! = mealPlans.count
//        }
//        else if clubsOrgsBool == true {
//            countrows! = clubsOrgs.count
//        }
//        else {
            //countrows = 10
//        }
        return countrows!
    }
    
    func pickerView(_ pickerView:UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
//        if mateTypeBool == true {
        var titleRow: String? = mateTypes[row]
//            return titleRow
//        }
        if collegeBool == true {
            titleRow! = colleges[row]
//            return titleRow
        }
        else if mealPlanBool == true {
            titleRow! = mealPlans[row]
//            return titleRow
        }
        else if clubsOrgsBool == true {
            titleRow! = clubsOrgs[row]
        }
        return titleRow!
    }
    
    func pickerView(_ pickerView:UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {

    }
    
    
    //select picker view value, send to selected button
    @IBAction func btnSelectPickerView(_ sender: Any) {
        
        viewPickerView.isHidden = true
        
        //mateType
        if mateTypeBool == true {
            btnMateTypePV.setTitle(mateTypes[pickerView.selectedRow(inComponent: 0)], for: .normal)
            mateTypeBool = false
        }
        
        //college
        if collegeBool == true {
            btnCollegePV.setTitle(colleges[pickerView.selectedRow(inComponent: 0)], for: .normal)
            collegeBool = false
        }
        
        //mealPlan
        if mealPlanBool == true {
            btnMealPlanPV.setTitle(mealPlans[pickerView.selectedRow(inComponent: 0)], for: .normal)
            mealPlanBool = false
        }
        
        //clubsOrgs
        if clubsOrgsBool == true {
            btnClubsOrgsPV.setTitle(clubsOrgs[pickerView.selectedRow(inComponent: 0)], for: .normal)
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
    
}


/* pickerView notes
1. create global variables (Booleans, start as false) for each item to be filtered (mateType, College, etc.)
2. create ibactions for each button
3. within the ibaction, change respective booleans from false to true
4. In pickerView, populate with array that has true boolean associated with it

 */


