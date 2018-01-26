//
//  EditProfileViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 10/18/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase
//import os.log


class EditProfileViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource,  UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    //create outlets
    @IBOutlet weak var tbFirstName: UITextField!
    @IBOutlet weak var tbLastName: UITextField!
    @IBOutlet weak var imgProfilePicture: UIImageView!

    @IBOutlet weak var pvMateType: UIPickerView!
    @IBOutlet weak var pvCollege: UIPickerView!
    
    
    //switch outlets (for saving values)
    var muteModeBool:Bool = false
    @IBAction func switchMuteMode(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            muteModeBool = true
        }
        else {
            muteModeBool = false
        }
    }
    
    var mealPlanBool:Bool = false
    @IBAction func switchMealPlan(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            mealPlanBool = true
        }
        else {
            mealPlanBool = false
        }
    }
    
    //change profile image
    
    @IBAction func btnChangeProfileImage(_ sender: Any) {
        //create instance of Image picker controller
        let picker = UIImagePickerController()
        //set delegate
        picker.delegate = self
        //set details
        //is the picture going to be editable(zoom)?
        picker.allowsEditing = true
        //what is the source type
        picker.sourceType = .photoLibrary
        //set the media type
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        //show photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //create holder variable for chosen image
        var chosenImage = UIImage()
        //save image into variable
        print(info)
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //update image view
        imgProfilePicture.image = chosenImage
        //dismiss
        dismiss(animated: true, completion: nil)
    }
    
    //what happens when the user hits cancel?
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
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
  
    override func viewWillAppear(_ animated: Bool) {
        
        dataRef.reference().child("USERS/\(uid!)").observe(.value, with: { snapshot in
            // get the entire snapshot dictionary
            if let dictionary = snapshot.value as? [String: Any]
            {
                var firstName = (dictionary["firstName"] as? String)!
                var lastName = (dictionary["lastName"] as? String)!
                var mateType = (dictionary["mateType"] as? String)!
                var college = (dictionary["college"] as? String)!
                var mealPlan = (dictionary["mealPlan"] as? Bool)!
                var muteMode = (dictionary["muteMode"] as? Bool)!

                //set switches
                //TODO: Load swith on/off based on t/f/ value in Db
//                if mealPlan == true {
//                    switchMealPlan.setOn
//                    }
//                    else
//                    {
//                        switchMealPlan.isOff = true
//                    }
//
//                    if muteMode == true {
//                        switchMuteMode.isOn = true
//                    }
//                    else
//                    {
//                        switchMuteMode.isOff = true
//                    }
                
                
                //String assignments
                    self.tbFirstName.text = "\(firstName)"
                    self.tbLastName.text = "\(lastName)"
                
                //picker view assignments
                    //college pv
                    if (college == "College of Arts and Sciences"){
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
                    else {
                        self.pvMateType.selectRow(0, inComponent: 0, animated: true)
                    }
                
                    //mateType pv
                    if (mateType == "Freshman"){
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
                    else if (mateType == "Other"){
                        self.pvMateType.selectRow(9, inComponent: 0, animated: true)
                    }
                    else {
                    self.pvMateType.selectRow(0, inComponent: 0, animated: true)
                    }
                
                //Bool assignments
                    //add switches
                
            }
        })
        
        //load profile image
        let profileImgRef = storageRef.child("imgProfilePictures/\(self.uid!).png")
        profileImgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Image does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uid!).png")!) as Data?
                    let imagePath = "imgProfilePictures/\(self.uid!).png"

                    let metaData = StorageMetadata()
                    metaData.contentType = "image/png"

                    self.storageRef.child(imagePath)
                        .putData(profileImageData!, metadata: metaData) { (metadata, error) in
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
        
        

        
        //        let urlKey = "http://html.com/wp-content/uploads/flamingo.jpg"
        //                self.imgProfilePicture.image = urlKey
        
        
        
        pvCollege.delegate = self
        pvCollege.dataSource = self
        pvMateType.delegate = self
        pvMateType.dataSource = self
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()


//
    }
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
       //CHECK if firstName or lastName text fields are blank
        if self.tbFirstName.text == "" || self.tbLastName.text == "" {
            let alertController = UIAlertController(title: "Error!", message: "Please ensure your first and last name are filled in!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
        
        let uid = Auth.auth().currentUser?.uid
    
        //update image
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            let imgProfilePictureRef =  storageRef.child("imgProfilePictures/\(self.uid!).png")
            
            if var uploadData = UIImagePNGRepresentation(self.imgProfilePicture.image!) {
                
                imgProfilePictureRef.putData(uploadData, metadata: metaData, completion:
                    { (metadata, error) in
                        if error != nil{
                            print(error)
                            return
                        }
                        print(metadata)
                        var imgProfilePictureURL:String? = "\(metadata?.downloadURL())"
                })
            }
            
            
        //switches
            
            
            
            
            //TODO -- get switches to save in Db
//            var muteMode: String!
//            var mealPlan: String!

            //MUteMode
//            if self.switchMUteMode.isOn == true {
//                muteMode = "true"
//            }
//            else {
//                muteMode = "false"
//            }
//
//            return muteMode

//            //mealPlan
//            if self.muteMode.isOn {
//                var mealPlan = "true"
//            }
//            else {
//                var mealPlan = "false"
//            }
            
            
        var firstName = self.tbFirstName.text
        var lastName = self.tbLastName.text
        var email = Auth.auth().currentUser?.email
        var muteMode = self.muteModeBool
        var mealPlan = self.mealPlanBool
        var college = colleges[pvCollege.selectedRow(inComponent: 0)]
        var mateType = mateTypes[pvMateType.selectedRow(inComponent: 0)]
//        var profilePictureURL = self.imgProfilePictureURL
            
            
        let userValues:[String:Any] =
            ["firstName": firstName,
             "lastName": lastName,
             "muteMode" : muteMode,
             "mealPlan" : mealPlan,
             "email" : email,
             "college" : college,
             "mateType" : mateType
//             "imgProfilePictureURL" : profilePictureURL
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
