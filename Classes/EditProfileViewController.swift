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
    
    //MARK: global variables
    var mateTypeBool = false
    var collegeBool = false
    var countrows: Int?
    
    
    //create outlets
    @IBOutlet weak var tbFirstName: UITextField!
    @IBOutlet weak var tbLastName: UITextField!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var btnMateTypePV: UIButton!
    @IBOutlet weak var btnCollegePV: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var viewPickerView: UIView!
    
    
    //unhide pickerView
        //mateType
    @IBAction func btnMateTypeAction(_ sender: Any) {
        if mateTypeBool == false {
            mateTypeBool = true
        }
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
    }
    
        //college
    @IBAction func btnCollegeAction(_ sender: Any) {
        if collegeBool == false {
            collegeBool = true
        }
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
    }
    

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
        "College of Nursing",
        "College of __",
        "College of __"
    ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView:UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        var countrows : Int? = 10
        return countrows!
    }
    
    func pickerView(_ pickerView:UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        var titleRow: String? = mateTypes[row]

        if collegeBool == true {
            titleRow! = colleges[row]
        }
        return titleRow!
    }
    
    func pickerView(_ pickerView:UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
    }
    
    @IBAction func btnSelect(_ sender: Any) {
        
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
                        self.pickerView.selectRow(1, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Business"){
                        self.pickerView.selectRow(2, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Communication"){
                        self.pickerView.selectRow(3, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Education"){
                        self.pickerView.selectRow(4, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Engineering"){
                        self.pickerView.selectRow(5, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Health Sciences"){
                        self.pickerView.selectRow(6, inComponent: 0, animated: true)
                    }
                    else if (college == "College of Nursing"){
                        self.pickerView.selectRow(7, inComponent: 0, animated: true)
                    }
                    else {
                        self.pickerView.selectRow(0, inComponent: 0, animated: true)
                    }
                
                    //mateType pv
                    if (mateType == "Freshman"){
                        self.pickerView.selectRow(1, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Sophomore"){
                        self.pickerView.selectRow(2, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Junior"){
                        self.pickerView.selectRow(3, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Senior"){
                        self.pickerView.selectRow(4, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Graudate Student"){
                        self.pickerView.selectRow(5, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Professor"){
                        self.pickerView.selectRow(6, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Administrator"){
                        self.pickerView.selectRow(7, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Jesuit"){
                        self.pickerView.selectRow(8, inComponent: 0, animated: true)
                    }
                    else if (mateType == "Other"){
                        self.pickerView.selectRow(9, inComponent: 0, animated: true)
                    }
                    else {
                    self.pickerView.selectRow(0, inComponent: 0, animated: true)
                    }
                
                //Bool assignments
                    //add switches
                
            }
        })
        
        //load profile image
        //TODO - reach into FB and get url displayed below, put it into variable, and use variable below
        if let url = NSURL(string: "https://firebasestorage.googleapis.com/v0/b/munch-mates-marquette.appspot.com/o/imgProfilePictures%2FFONO4mt4CPgNxlXDGv5YMh8pFZo2.png?alt=media&token=b62a293d-c2ce-491b-b2d2-5447c532a5bb") {
            if let data = NSData(contentsOf: url as URL) {
                imgProfilePicture.contentMode = UIViewContentMode.scaleAspectFit
                imgProfilePicture.image = UIImage(data: data as Data)
            }
        }
        
        
//        let profileImgRef = storageRef.child("imgProfilePictures/\(self.uid!).png")
//        profileImgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//            if error != nil {
//                let errorDesc = error?.localizedDescription
//                if errorDesc == "Image does not exist." {
//                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uid!).png")!) as Data?
//                    let imagePath = "imgProfilePictures/\(self.uid!).png"
//
//                    let metaData = StorageMetadata()
//                    metaData.contentType = "image/png"
//
//                    self.storageRef.child(imagePath)
//                        .putData(profileImageData!, metadata: metaData) { (metadata, error) in
//                            if let error = error {
//                                print ("Uploading Error: \(error)")
//                                return
//                            }
//                    }
//                    self.userProfileImage = UIImage(named: "\(self.uid!).png")
//                } else {
//                    return
//                }
//            } else {
//                self.userProfileImage = UIImage(data: data!)
//                self.imgProfilePicture.image = self.userProfileImage
//            }
//        }
        
        
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    
    override func viewDidLoad() {
        
        viewPickerView.isHidden = true
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        super.viewDidLoad()

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
        var college = colleges[pickerView.selectedRow(inComponent: 0)]
        var mateType = mateTypes[pickerView.selectedRow(inComponent: 0)]
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
