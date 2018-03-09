//
//  EditProfileViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 10/18/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource,  UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    //MARK: global variables
    var mateTypeBool = false
    var collegeBool = false
    var countrows: Int?
    var clubsOrgsDetails = clubsOrgsStruct()
    var selfUserClubsOrgs = clubsOrgsStruct()
    let ref = Database.database()
    let cellId = "EditProfileButtonName"
    //mateType
    var mateTypeStruct: [FilterStructMateType] = []
    var selectedFilterValueMateType = FilterStructMateType()
    //college
    var collegeStruct: [FilterStructCollege] = []
    var selectedFilterValueCollege = FilterStructCollege()
    
    //store clubs orgs to be saved
    var saveClubsOrgs: [saveClubsOrgsStruct] = []
    var saveClubsOrgsEditProfile = saveClubsOrgsStruct()
    
    //create outlets
    @IBOutlet weak var tbFirstName: UITextField!
    @IBOutlet weak var tbLastName: UITextField!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var btnMateTypePV: UIButton!
    @IBOutlet weak var btnCollegePV: UIButton!
    @IBOutlet weak var viewPickerView: UIView!
    @IBOutlet weak var tbCity: UITextField!
    @IBOutlet weak var tbStateCountry: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    //unhide pickerView
        //mateType
    @IBAction func btnMateTypeAction(_ sender: Any) {
        mateTypeBool = true
        collegeBool = false
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
    
        //college
    @IBAction func btnCollegeAction(_ sender: Any) {
        mateTypeBool = false
        collegeBool = true
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
        else {
            return 0
        }
    }
    
    //What is in each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! EditProfileViewCell
        if mateTypeBool == true {
            let mateType = self.mateTypeStruct[indexPath.row]
            cell.lblEditProfileButtonName?.text = mateType.mateTypeName
        }
        else if collegeBool == true {
            let college = self.collegeStruct[indexPath.row]
            cell.lblEditProfileButtonName?.text = college.collegeName
        }
        
        return cell
        
    }
    
    var mateTypeName:String = " "
    var collegeName:String = " "
    
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
    }
    

    //switch outlets (for saving values)
    var muteModeBool:Bool = false
    @IBOutlet weak var switchMuteModeOutlet: UISwitch!
    @IBAction func switchMuteMode(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            muteModeBool = true
        }
        else {
            muteModeBool = false
        }
    }
    
    var mealPlanBool:Bool = false
    @IBOutlet weak var switchMealPlanOutlet: UISwitch!
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
    
    //cancel
    @IBAction func btnCancel(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelfProfileViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    //MARK - variables
    let dataRef = Database.database()
    let storageRef = Storage.storage().reference()
    var userProfileImage: UIImage?
    let uid = Auth.auth().currentUser?.uid
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        //create holder variable for chosen image
        var chosenImage = UIImage()
        //save image into variable
        print(info)
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        //update image view
        imgProfilePicture.image = chosenImage
        //dismiss
        dismiss(animated: true, completion: nil)
    }
    
    //what happens when the user hits cancel?
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnSelect(_ sender: Any) {
        viewPickerView.isHidden = true
        mateTypeBool = false
        collegeBool = false
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        
        dataRef.reference().child("USERS/\(uid!)").observe(.value, with: { snapshot in
            // get the entire snapshot dictionary
            if let dictionary = snapshot.value as? [String: Any]
            {
                //MARK - Local Variables
                var firstName = (dictionary["firstName"] as? String)!
                var lastName = (dictionary["lastName"] as? String)!
                var mateType = (dictionary["mateType"] as? String)!
                var college = (dictionary["college"] as? String)!
                var mealPlan = (dictionary["mealPlan"] as! Bool)
                var muteMode = (dictionary["muteMode"] as! Bool)
                var city = (dictionary["city"] as? String)!
                var stateCountry = (dictionary["stateCountry"] as? String)!

                //set switches and variables
                    //mealPlan Switches
                    if mealPlan == true && mealPlan != nil {
                        self.switchMealPlanOutlet.setOn(true, animated: false)
                        self.mealPlanBool = true
                    }
                    else {
                        self.switchMealPlanOutlet.setOn(false, animated: false)
                        self.mealPlanBool = false
                    }
                
                    //muteMode switches
                    if muteMode == true {
                        self.switchMuteModeOutlet.setOn(true, animated: false)
                        self.muteModeBool = true
                    }
                    else {
                        self.switchMuteModeOutlet.setOn(false, animated: false)
                        self.muteModeBool = false
                    }
                
                
                //String assignments
                    self.tbFirstName.text = "\(firstName)"
                    self.tbLastName.text = "\(lastName)"
                    self.tbCity.text = "\(city)"
                    self.tbStateCountry.text = "\(stateCountry)"
        }
        })
        

    
        
//        pickerView.delegate = self
//        pickerView.dataSource = self
        
    }
    
////////////////////LOAD INFOMRATION TO VIEW CONTROLLER//////////////////
    override func viewDidLoad() {
        
        dataRef.reference().child("USERS/\(uid!)").observe(.value, with: { snapshot in
            // get the entire snapshot dictionary
            if let dictionary = snapshot.value as? [String: Any]
            {
                var mateType = (dictionary["mateType"] as? String)!
                var college = (dictionary["college"] as? String)!
                
                //Button assignments
                self.btnCollegePV.setTitle("\(college)", for: .normal)
                self.btnMateTypePV.setTitle("\(mateType)", for: .normal)
                
            }
        })
        

        //load profile image
        let profileImgRef = storageRef.child("imgProfilePictures/\(self.uid!).png")
        profileImgRef.getData(maxSize: 50 * 1024 * 1024) { data, error in
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
        
        
        // Fetch the download URL
//        self.btnCollegePV.setTitle("https...", for: .normal)

//        if let url = NSURL(string: "\(userProfileImageURL)") {
//            if let data = NSData(contentsOf: url as URL) {
//                imgProfilePicture.contentMode = UIViewContentMode.scaleAspectFit
//                imgProfilePicture.image = UIImage(data: data as Data)
//            }
//        }
        

        viewPickerView.isHidden = true
    
        
        super.viewDidLoad()

    }
    
    
/////////////////////////SAVING DATA INTO DATABASE/////////////////////////////
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
        
        //let uid = Auth.auth().currentUser?.uid
    
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
            
            
        //insert User info in Db
        var firstName = self.tbFirstName.text
        var lastName = self.tbLastName.text
        var email = Auth.auth().currentUser?.email
        var muteMode = self.muteModeBool
        var mealPlan = self.mealPlanBool
        var college = self.btnCollegePV.currentTitle
        var mateType = self.btnMateTypePV.currentTitle
        var city = self.tbCity.text
        var stateCountry = self.tbStateCountry.text
            
        let userValues:[String:Any] =
            [
             "firstName": firstName,
             "lastName": lastName,
             "muteMode" : muteMode,
             "mealPlan" : mealPlan,
             "email" : email,
             "college" : college,
             "mateType" : mateType,
             "uid":uid,
             "city":city,
             "stateCountry":stateCountry
            ]
        
            dataRef.reference().child("USERS/\(uid!)").setValue(userValues)
            
            //Insert clubs org info into Db
            let clubsOrgsNameValue = clubsOrgsDetails.clubsOrgsName
            let clubsOrgsIdValue = clubsOrgsDetails.clubsOrgsId
            let clubsOrgsValues:[String:Any] =
                [
                    "clubsOrgsName":clubsOrgsNameValue,
                    "clubsOrgsId":clubsOrgsIdValue
                ]
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = firstName! + " " + lastName!
            changeRequest?.commitChanges { (error) in
                // ...
            }
            
            dataRef.reference().child("USERS/\(uid!)/clubsOrgs/\(clubsOrgsIdValue)/").setValue(clubsOrgsValues)
        
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
