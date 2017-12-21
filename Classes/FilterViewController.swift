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
        
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
        
    }
    
    @IBAction func btnCollegePVAction(_ sender: Any) {
        
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
        //TRYING TO CALL ARRAY BASED ON SELECTED BUTTON
//        if btnMateTypePVAction(Any).touchInside = true {
//            var countrows = mateTypes.count
//        }
//        else if btnCollegePVAction(Any).touchInside = true {
//            var countrows = colleges.count
//        }
//        else {
//            var countrows = 0
//        }
//        return countrows
        var countrows = mateTypes.count
        return countrows
        
    }
    
    func pickerView(_ pickerView:UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let titleRow = mateTypes[row]
        return titleRow
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
