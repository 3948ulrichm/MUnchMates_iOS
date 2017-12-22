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
    
    //MARK: Outlets
    @IBOutlet weak var btnMateTypePV: UIButton!
    @IBOutlet weak var btnCollegePV: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var viewPickerView: UIView!
    
    override func viewDidLoad() {

        viewPickerView.isHidden = true
        
        pickerView.delegate = self
        pickerView.dataSource = self

        super.viewDidLoad()
    }

    @IBAction func btnMateTypePVAction(_ sender: Any) {
        var mateTypeBool = true
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
        
    }
    
    @IBAction func btnCollegePVAction(_ sender: Any) {
        
        var collegeBool = true
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
    }
    
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
        "College of Nursing"
    ]
    
    
    
    //picker view
        //populate button with text selected in pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView:UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if mateTypeBool == true {
            var countrows = mateTypes.count
            return countrows
        }
        else if collegeBool == true {
            var countrows = colleges.count
            return countrows
        }
//        return countrows
    }
    
    func pickerView(_ pickerView:UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if mateTypeBool == true {
            var titleRow = mateTypes[row]
            return titleRow
        }
        else if collegeBool == true {
            var titleRow = colleges[row]
            return titleRow
        }
//        return titleRow
    }
    
    func pickerView(_ pickerView:UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {

    }
    
    @IBAction func btnSelectPickerView(_ sender: Any) {
        
        btnMateTypePV.setTitle(mateTypes[pickerView.selectedRow(inComponent: 0)], for: .normal)
        btnCollegePV.setTitle(mateTypes[pickerView.selectedRow(inComponent: 0)], for: .normal)
        viewPickerView.isHidden = true
        
    }
    
    
    
    
    
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


