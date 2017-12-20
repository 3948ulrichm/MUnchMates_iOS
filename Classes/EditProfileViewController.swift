//
//  EditProfileViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 10/18/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //create outlets
    @IBOutlet weak var tbFirstName: UITextField!
    @IBOutlet weak var tbLastName: UITextField!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var pvMateType: UIPickerView!
    @IBOutlet weak var pvCollege: UIPickerView!
    
    let dataRef = Database.database()
    let storageRef = Storage.storage().reference()
    var userProfileImage: UIImage?
    let uid = Auth.auth().currentUser?.uid

    
//    pvCollege.selectRow(3, inComponent: 0, animated: true)
//    pvMateType.selectRow(5, inComponent: 0, animated: true)
    
    //set up picker views
    let mateTypes = [
        " ",
        "Freshman",
        "Sophomore",
        "Junior",
        "Senior",
        "Graudate Student",
        "Professor",
        "Administrator",
        "Jesuit",
        "Superhero",
        "Other"
    ]
    
    let colleges = [
        " ",
        "College of Arts and Sciences",
        "College of Business",
        "College of Communication",
        "College of Education",
        "College of Engineering",
        "College of Health Sciences",
        "College of Nursing",
        "College of Comics"
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
  
    override func viewWillAppear(_ animated: Bool) {
        
        dataRef.reference().child("USERS/\(uid!)").observe(.value, with: { snapshot in
            // get the entire snapshot dictionary
            if let dictionary = snapshot.value as? [String: Any]
            {
                var firstName = (dictionary["firstName"] as? String)!
                var lastName = (dictionary["lastName"] as? String)!
                var mateType = (dictionary["mateType"] as? String)!
                var college = (dictionary["college"] as? String)!

                //                var mealPlan = (dictionary["mealPlan"] as? Bool)!
                //                var mateType = (dictionary["mateType"] as? String)!
                
                //String assignments
                    self.tbFirstName.text = "\(firstName)"
                    self.tbLastName.text = "\(lastName)"
                
                //picker view assignments
                    //college pv
                    if (college == " "){
                        self.pvCollege.selectRow(0, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Arts and Sciences"){
                        self.pvCollege.selectRow(1, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Business"){
                        self.pvCollege.selectRow(2, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Communication"){
                        self.pvCollege.selectRow(3, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Education"){
                        self.pvCollege.selectRow(4, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Engineering"){
                        self.pvCollege.selectRow(5, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Health Sciences"){
                        self.pvCollege.selectRow(6, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Nursing"){
                        self.pvCollege.selectRow(7, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Comics"){
                        self.pvCollege.selectRow(8, inComponent: 0, animated: true)
                    }
                
                    //mateType pv
                    if (mateType == " "){
                        self.pvMateType.selectRow(0, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Freshman"){
                        self.pvMateType.selectRow(1, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Sophomore"){
                        self.pvMateType.selectRow(2, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Junior"){
                        self.pvMateType.selectRow(3, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Senior"){
                        self.pvMateType.selectRow(4, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Graudate Student"){
                        self.pvMateType.selectRow(5, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Professor"){
                        self.pvMateType.selectRow(6, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Administrator"){
                        self.pvMateType.selectRow(7, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Jesuit"){
                        self.pvMateType.selectRow(8, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Superhero"){
                        self.pvMateType.selectRow(9, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Other"){
                        self.pvMateType.selectRow(10, inComponent: 0, animated: true)
                    }
                
                //Bool assignments
                    //add switches
                
            }
        })
        
        pvCollege.delegate = self
        pvCollege.dataSource = self
        pvMateType.delegate = self
        pvMateType.dataSource = self
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let profileImgRef = storageRef.child("imgProfilePictures/\(self.uid!).png")
        profileImgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Image does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uid!).png")!) as Data?
                    let imagePath = "imgProfilePictures/\(self.uid!).png"
                    
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/png"
                    
                    self.storageRef.child(imagePath)
                        .putData(profileImageData!, metadata: metadata) { (metadata, error) in
                            if let error = error {
                                print ("Uploading Error: \(error)")
                                return
                            }
                    }
                    self.userProfileImage = UIImage(named: "\(self.uid!).png")
                } else {
                    return
                }
            } else {
                self.userProfileImage = UIImage(data: data!)
                self.imgProfilePicture.image = self.userProfileImage
            }
        }
        
    }
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
       //CHECK if firstName or lastName text fields are blank
        //currently an alert pops up but the Db still updates with just a first name or last name... FIX this so the Db doesnt update if there is only one name
        if self.tbFirstName.text == "" || self.tbLastName.text == "" {
            let alertController = UIAlertController(title: "Error!", message: "Please ensure your first and last name are filled in!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
        
        let uid = Auth.auth().currentUser?.uid
    
        var firstName = self.tbFirstName.text
        var lastName = self.tbLastName.text
        var muteMode = false
        var mealPlan = false
        var email = Auth.auth().currentUser?.email
        var college = colleges[pvCollege.selectedRow(inComponent: 0)]
        var mateType = mateTypes[pvMateType.selectedRow(inComponent: 0)]
        
        let userValues:[String:Any] =
            ["firstName": firstName,
             "lastName": lastName,
             "muteMode" : muteMode,
             "mealPlan" : mealPlan,
             "email" : email,
             "college" : college,
             "mateType" : mateType
            ]
        
            dataRef.reference().child("USERS/\(uid!)").setValue(userValues)
            
            //segue to PledgeViewController
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelfProfileViewController")
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
