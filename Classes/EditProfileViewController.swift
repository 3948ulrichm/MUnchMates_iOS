//
//  EditProfileViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 10/18/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class EditProfileViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource,  UIImagePickerControllerDelegate,  UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    //MARK: global variables
    var mateTypeBool = false
    var collegeBool = false
    var countrows: Int?
    var loadImageBool = false

    //var clubsOrgsDetails = clubsOrgsStruct()
    //var selfUserClubsOrgs = clubsOrgsStruct()
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
    
    //send true bool statement in DelayedImageLoadStruct if save btn is selected
    var delayImageEditProfileArray: [DelayedImageLoadStruct] = []
    var delayImageEditProfile = DelayedImageLoadStruct()
    
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
    
    @IBOutlet weak var lblSaving: UILabel!
    
    @IBOutlet weak var imgLogoBottom: UIImageView!
    
    @IBAction func btnHelpDeskEmail(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["MUnchMatesHelpDesk@gmail.com"])
        composeVC.setSubject("Help Desk Inquiry")
        composeVC.setMessageBody("<b>If you have questions, comments, or concerns about the app, let us know:</b><br>", isHTML: true)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    @IBAction func btnSendPasswordReset(_ sender: Any) {
        
        var email: String?
        email = Auth.auth().currentUser?.email
        //reset via email
        Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
            
        }
        
        let alertController = UIAlertController(title: "Email sent!", message: "A password reset email has been sent to \(email!)", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
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
        
        self.loadImageBool = true
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
        
        //release keyboard when non-keyboard area of screen is tapped
        self.hideKeyboardWhenTappedAround()
        
        //hide lblSave
        lblSaving.isHidden = true
        
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
        
    }
    
////////////////////LOAD INFOMRATION TO VIEW CONTROLLER//////////////////
    override func viewDidLoad() {
        
        //add done button to textboc keyboards
//        tbFirstName.returnKeyType = .done
//        tbFirstName.resignFirstResponder()
//        tbLastName.returnKeyType = .done
//        tbCity.returnKeyType = .done
//        tbStateCountry.returnKeyType = .done

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
        
        viewPickerView.isHidden = true
        
        //add done button to keyboard
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        doneButton.tintColor = UIColor.MUnchMatesBlue
        
        toolBar.setItems([doneButton], animated: false)
        
        tbFirstName.inputAccessoryView = toolBar
        tbLastName.inputAccessoryView = toolBar
        tbCity.inputAccessoryView = toolBar
        tbStateCountry.inputAccessoryView = toolBar
        
        super.viewDidLoad()


    }

func doneClicked() {
    view.endEditing(true)
}
    
    
/////////////////////////SAVING DATA INTO DATABASE/////////////////////////////
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
       //hide nav bar img, unhide saving label
        
        imgLogoBottom.isHidden = true
        lblSaving.isHidden = false

        
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
            
        //insert User info in Db
        var firstName = self.tbFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var lastName = self.tbLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var email = Auth.auth().currentUser?.email
        var muteMode = self.muteModeBool
        var mealPlan = self.mealPlanBool
        var college = self.btnCollegePV.currentTitle
        var mateType = self.btnMateTypePV.currentTitle
        var city = self.tbCity.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var stateCountry = self.tbStateCountry.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = firstName! + " " + lastName!
            changeRequest?.commitChanges { (error) in
                // ...
            }

            dataRef.reference().child("USERS/\(uid!)/firstName").setValue(firstName)
            dataRef.reference().child("USERS/\(uid!)/lastName").setValue(lastName)
            dataRef.reference().child("USERS/\(uid!)/muteMode").setValue(muteMode)
            dataRef.reference().child("USERS/\(uid!)/mealPlan").setValue(mealPlan)
            dataRef.reference().child("USERS/\(uid!)/email").setValue(email)
            dataRef.reference().child("USERS/\(uid!)/college").setValue(college)
            dataRef.reference().child("USERS/\(uid!)/mateType").setValue(mateType)
            dataRef.reference().child("USERS/\(uid!)/uid").setValue(uid)
            dataRef.reference().child("USERS/\(uid!)/city").setValue(city)
            dataRef.reference().child("USERS/\(uid!)/stateCountry").setValue(stateCountry)
            
            
            delayImageEditProfile = DelayedImageLoadStruct(savedImage: self.loadImageBool)
            performSegue(withIdentifier: "EditProfile2SelfProfile", sender: self)

            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelfProfileViewController")
//            self.present(vc!, animated: true, completion: nil)
//            vc.delayImageSelfProfile = delayImageEditProfile

        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfile2SelfProfile" {
            let vc = segue.destination as! SelfProfileViewController
            vc.delayImageSelfProfile = delayImageEditProfile
        }
    }
    
    
    //DELETE USER
    
    
    @IBAction func btnDeleteAccount(_ sender: Any) {
        
        //alert message
        let alertController = UIAlertController(title: "Wait!", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        //delete btn in alert (variable)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive,
         //action when btn is selected
         handler: { action in
            let user = Auth.auth().currentUser
            print(user)
            user!.delete { error in }
                //poorly done check^, but if code is written correctly, this should be ok... user will delete from db, profile pic will be deleted, and segue to login will happen whether or not auth delete occurs. Fix later!
            
                    //successful auth delete
            
                    //remove user from database
                    Database.database().reference().child("USERS/\(self.uid!)").removeValue()
                    
                    //delete user profile picture
                    self.storageRef.child("imgProfilePictures/\(self.uid!).png").delete()
            
                    //unsure user is logged out --> This prevents autologin after segue
                        do {
                            try Auth.auth().signOut()
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
            
                    //segue to login
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                    self.present(vc!, animated: true, completion: nil)
            
        })
        //cancel btn in alert (variable)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        { (result: UIAlertAction) -> Void in
        }
        //create buttons using varibles above
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
