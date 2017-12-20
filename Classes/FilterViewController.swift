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
    
  
    @IBOutlet weak var pvCollege: UIPickerView!
    
    @IBOutlet weak var pvMateType: UIPickerView!
    
    override func viewDidLoad() {
        
        pvCollege.delegate = self
        pvCollege.dataSource = self
        pvMateType.delegate = self
        pvMateType.dataSource = self
        
        super.viewDidLoad()
    }
    
    
    //picker views
    //consider changing to text view picker view
    //www.youtube.com/watch?v=QdLFd3wNqV8
    let mateTypes = [
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
    
    let colleges = [
            "All",
            "College of Arts and Sciences",
            "College of Business",
            "College of Communication",
            "College of Education",
            "College of Engineering",
            "College of Health Sciences",
            "College of Nursing"
        ]
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int
        {
            return 1
        }
    
        func pickerView(_ pickerView:UIPickerView, numberOfRowsInComponent component: Int) -> Int
        {
            var countrows : Int = mateTypes.count
            if pickerView == pvCollege {
                countrows = self.colleges.count
            }
            return countrows
        }
    
        func pickerView(_ pickerView:UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
        {
            if pickerView == pvMateType {
                let titleRow = mateTypes[row]
                return titleRow
            } else if pickerView == pvCollege {
                let titleRow = colleges[row]
                return titleRow
            }
            
            return " "
        }
    
        func pickerView(_ pickerView:UIPickerView, didSelectRow row: Int, inComponent component: Int)
        {

        }

    //Throwing error... fix this
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
