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

// this class is for the editing profile view controller, which allows a user to edit their profile. A user can access this page by going to their profile and clicking on the upper right nav bar button.
class EditProfileViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource,  UIImagePickerControllerDelegate,  UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // global variables
    var countrows: Int?
    var loadImageBool = false
    let dataRef = Database.database()
    let storageRef = Storage.storage().reference()
    var userProfileImage: UIImage?
    let uid = Auth.auth().currentUser?.uid
    
    // mateTypeBool and collegeBool are used to let the table view know what information needs to be loaded from the database. when the mate type button is pressed, mateTypeBool becomes to true. when the college button is pressed, collegeBool becomes true. the table view looks to see what bool is true and will load data based on what bool is true.
    var mateTypeBool = false
    var collegeBool = false
    
    // "ref" can be called in the code to shorten a line of code when calling the database. Search "ref." for an example of this.
    let ref = Database.database()
    
    // when the mate type or college button is pressed a view pops up containing a table view inside of it with choices to change the mate type or college. each choice is in a table view cell. this is the name of table view cell (named in main.storyboard) when a user is updating their mate type or college.
    let cellId = "EditProfileButtonName"
    
    // mateType struct. this is used when the user clicks their current mate type (button) and the mate type list loads to the table view so a user can select a new mate type.
    var mateTypeStruct: [FilterStructMateType] = []
    var selectedFilterValueMateType = FilterStructMateType()
    
    // college struct. this is used when the user clicks their current college (button) and the college list loads to the table view so a user can select a new mate type.
    var collegeStruct: [FilterStructCollege] = []
    var selectedFilterValueCollege = FilterStructCollege()
    
    // originally, when the save button was clicked, the app would immediately go to SelfProfileViewController. bc this happened so quickly, there was not enough time for the new profile picture to upload and download to/from "Storage"in Firebase. The struct below contains a bool, true/false. If the "Update Headshot" button is pressed in EditProfileViewController, the bool will change from false to true. If this bool is true when "Save" is clicked, it will delay the profile picture from displaying for 5 seconds to ensure there is enough time for the new profile picture to upload, download, and display in SelfProfileViewController. during the five seconds a label will display instead of the image. the label will say "Loading your beautiful headshot!". This text can be updated in main.storyboard.
    var delayImageEditProfileArray: [DelayedImageLoadStruct] = []
    var delayImageEditProfile = DelayedImageLoadStruct()
    
    // create outlets
    @IBOutlet weak var tbFirstName: UITextField!
    @IBOutlet weak var tbLastName: UITextField!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var btnMateTypePV: UIButton!
    @IBOutlet weak var btnCollegePV: UIButton!
    @IBOutlet weak var viewPickerView: UIView!
    @IBOutlet weak var tbCity: UITextField!
    @IBOutlet weak var tbStateCountry: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // this outlet/label displays on the nav bar when the save button is pressed.
    @IBOutlet weak var lblSaving: UILabel!
    
    // this image is the MUnchMates logo without the apple, just the text. it displays on the nav bar, but disappears when save is pressed and lblSaving appears instead.
    @IBOutlet weak var imgLogoBottom: UIImageView!
    
    // when the help desk button is pressed, the user's mail app loads, sending a message to "MUnchMates@marquette.edu" with the subject "Help Desk Inquiry"
    @IBAction func btnHelpDeskEmail(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // configure the fields of the interface
        composeVC.setToRecipients(["MUnchMates@marquette.edu"])
        composeVC.setSubject("Help Desk Inquiry")
        composeVC.setMessageBody("<b>If you have questions, comments, or concerns about the app, let us know:</b><br>", isHTML: true)
        
        // present the view controller modally
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    // when this button is pressed, a reset password will be emailed to the user. the email sends right away, without any "are you sure"-esk popups. a future improvement will be to add a popup letting the user know that this button sends a reset password email to their email. if the user does not want to change their password, they can just ignore the email. this is explained to them in the "email sent" popup and in the email that gets sent.
    @IBAction func btnSendPasswordReset(_ sender: Any) {
        var email: String?
        
        // finds user's email, looking in Authentication section of Firebase
        email = Auth.auth().currentUser?.email
        
        // reset email sent
        Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
        }
        
        // popup for user to day that the password reset email has been sent
        let alertController = UIAlertController(title: "Email sent!", message: "A password reset email has been sent to \(email!). If you do not want to reset your password, just ignore the email!", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Thanks!", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // ACTION: mateType button. when a user clicks the button with their current mate type a selection view pops up with a table view that will contain a list of mate types the user is able to select.
    @IBAction func btnMateTypeAction(_ sender: Any) {
        // mateTypeBool becomes true to let the table view know to load mate types. collegeBool also become false to ensure that only one bool is true.
        mateTypeBool = true
        collegeBool = false
        
        // viewPickerView is the name of the view with the table view in it. orginally, we were going to use a picker view, but we decided a table view was better. we had already named the view "viewPickerView" and never changed it, but this is refering to a table view NOT a picker view.
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
        
        // code checks if mateTypeBool is true. if so, it will reach into the database's "LISTS" node and grab a list of all mate types.
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

    // ACTION: college button. when a user clicks the button with their current college a selection view pops up with a table view that will contain a list of colleges the user is able to select.
    @IBAction func btnCollegeAction(_ sender: Any) {
        
        // collegeBool becomes true to let the table view know to load mate types. mateTypeBool also become false to ensure that only one bool is true.
        mateTypeBool = false
        collegeBool = true
        
        // viewPickerView is the name of the view with the table view in it. orginally, we were going to use a picker view, but we decided a table view was better. we had already named the view "viewPickerView" and never changed it, but this is refering to a table view NOT a picker view.
        if viewPickerView.isHidden == true {
            viewPickerView.isHidden = false
        }
        
        // code checks if collegeBool is true. if so, it will reach into the database's "LISTS" node and grab a list of all colleges.
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
    
    // table view (next four functions)
    // defines how many sections (left to right) are in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // how many rows are in the table view? In this case, it depends if the user selects mate type or college. again, we use the mateTypeBool and collegeBool method to define the count. depending on which one is true, the code uses the row count from its struct to define how many rows will be needed in the table view.
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
    
    // what is in each cell? depending on which cells bool is true, the cells will populate with the names of each mate type or college from the LISTS node in Firebase.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cellId is defined as a global variable at the top of this class and is the "identifier" of the cell that will display the mates types/colleges.
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
    
    // these variables are defined to be used below in the function
    var mateTypeName:String = " "
    var collegeName:String = " "
    
    // what happens if you select a row? when a row is selected, the title of the button is changed to reflect the selection made by the user and the table view is dismissed. the button title will then be the new mate type / college when the profile is saved.
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
    

    // switch outlets
    
    // muteMode
    // muteModeBool is declared. false is just a placeholder.
    var muteModeBool:Bool = false
    
    // outlet is used to load switch on or off depending if mute mode bool is true or false in Firebase
    @IBOutlet weak var switchMuteModeOutlet: UISwitch!
    
    // when switch is toggled on/off, muteModeBool toggles true/false. this bool is sent to Firebase when saving profile.
    @IBAction func switchMuteMode(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            muteModeBool = true
        }
        else {
            muteModeBool = false
        }
    }
    
    // mealPlan
    // mealPlanBool is declared. false is just a placeholder.
    var mealPlanBool:Bool = false
    
    // outlet is used to load switch on or off depending if meal plan bool is true or false in Firebase
    @IBOutlet weak var switchMealPlanOutlet: UISwitch!
    
    // when switch is toggled on/off, mealPlanBool toggles true/false. this bool is sent to Firebase when saving profile.
    @IBAction func switchMealPlan(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            mealPlanBool = true
        }
        else {
            mealPlanBool = false
        }
    }
    
    // ACTION: "Update Headshot" button
    @IBAction func btnChangeProfileImage(_ sender: Any) {
        // create instance of Image picker controller
        let picker = UIImagePickerController()
        // set delegate
        picker.delegate = self
        // set details
        // is the picture going to be editable(zoom)?
        picker.allowsEditing = true
        // what is the source type
        picker.sourceType = .photoLibrary
        // set the media type
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        // show photoLibrary
        present(picker, animated: true, completion: nil)
        
        self.loadImageBool = true
    }
    
    // ACTION: cancel button on right side of nav bar, top right of view controller
    @IBAction func btnCancel(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelfProfileViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    // MARK - variables

    
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
                var emailNotifications = (dictionary["emailNotifications"] as! Bool)
                var city = (dictionary["city"] as? String)!
                var stateCountry = (dictionary["stateCountry"] as? String)!

                //set switches and variables
                    //mealPlan switch
                    if mealPlan == true && mealPlan != nil {
                        self.switchMealPlanOutlet.setOn(true, animated: false)
                        self.mealPlanBool = true
                    }
                    else {
                        self.switchMealPlanOutlet.setOn(false, animated: false)
                        self.mealPlanBool = false
                    }
                
                    //muteMode switch
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
        
        // load mateType and college to populate btnCollegePV and btnMateTypePV titles
        dataRef.reference().child("USERS/\(uid!)").observe(.value, with: { snapshot in
            // get the entire snapshot dictionary
            if let dictionary = snapshot.value as? [String: Any]
            {
                // declare variables using data from Firebase
                var mateType = (dictionary["mateType"] as? String)!
                var college = (dictionary["college"] as? String)!
                
                // button title assignments
                self.btnCollegePV.setTitle("\(college)", for: .normal)
                self.btnMateTypePV.setTitle("\(mateType)", for: .normal)
            }
        })
        
        // load profile image
        let profileImgRef = storageRef.child("imgProfilePictures/\(self.uid!).png")
        profileImgRef.getData(maxSize: 50 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Image does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "\(self.uid!).png")!) as Data?
                    // user's profile picture is named their uid followed by ".png". for example, if Tim is the user and has a uid of "abc123", Tim's profile picture file name will be "abc123.png". this makes it easily accessible when Tim is using the app, bc all we need to do is call his uid.
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
        
        // when vc loads, viewPickerView (the view and table view that displays colleges and mate types) is hidden from the user. this will be displayed when either the college or mate type button is pressed.
        viewPickerView.isHidden = true
        
        // add done button to keyboard
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        // makes done button MUnchMatesBlue, which is the color blue found in MUnchMates' logo. MUnchMatesBlue is defined in UIExtensions.swift
        doneButton.tintColor = UIColor.MUnchMatesBlue
        
        toolBar.setItems([doneButton], animated: false)
        
        // this adds the toolbar with the done button to every textbox in the vc
        tbFirstName.inputAccessoryView = toolBar
        tbLastName.inputAccessoryView = toolBar
        tbCity.inputAccessoryView = toolBar
        tbStateCountry.inputAccessoryView = toolBar
        
        super.viewDidLoad()
    }

    // function that dismisses keyboard and is called in viewDidLoad above
    func doneClicked() {
        view.endEditing(true)
    }
    
    // SAVING DATA IN FIREBASE
    // ACTION: save button
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
       
        // hide nav bar image, unhide "Saving" label
        imgLogoBottom.isHidden = true
        lblSaving.isHidden = false

        // CHECK if firstName or lastName text fields are blank. If so, an alert will display telling the user that both textboxes must be filled before they can save their profile.
        if self.tbFirstName.text == "" || self.tbLastName.text == "" {
            let alertController = UIAlertController(title: "Error!", message: "Please ensure your first and last name are not blank", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        // if firstName AND lastName text fields are NOT blank, then the data in the view controller is saved to Firebase.
        else {
            let uid = Auth.auth().currentUser?.uid
    
            // update image to "Storage". if the image is new, the old image will be overwritten.
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            
            // user's profile picture is named their uid followed by ".png". for example, if Tim is the user and has a uid of "abc123", Tim's profile picture file name will be "abc123.png". this makes it easily accessible when Tim is using the app, bc all we need to do is call his uid.
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
            
        // insert user's info in "Database". first, put each data point that needs to be updated into a variable.
        var firstName = self.tbFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var lastName = self.tbLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var email = Auth.auth().currentUser?.email
        var muteMode = self.muteModeBool
        var mealPlan = self.mealPlanBool
        var college = self.btnCollegePV.currentTitle
        var mateType = self.btnMateTypePV.currentTitle
        var city = self.tbCity.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var stateCountry = self.tbStateCountry.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var emailNotifications = false

            // this changes name in "Authentication" if the user changes their name
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = firstName! + " " + lastName!
            changeRequest?.commitChanges { (error) in
                // ...
            }

            // takes variables and saves them in Firebase Database
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
            dataRef.reference().child("USERS/\(uid!)/emailNotifications").setValue(emailNotifications)

            // sends bool to see if "Update Headshot" was pressed. if so, the bool will be true. if the bool is true the profile picture in SelfProfileViewController will delay loading for five seconds to allow time for the new image to updload and download to and from Storage in Firebase. previously, when we had no delay, SelfProfileViewController would display the old profile image bc there was not enough time for the new image to upload/download.
            delayImageEditProfile = DelayedImageLoadStruct(savedImage: self.loadImageBool)
            performSegue(withIdentifier: "EditProfile2SelfProfile", sender: self)
        }
    }
    
    // this is the segue used when the save button is pressed. the segue passes the delay image struct, which contains the bool that will delay the SelfProfileViewController image if true.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfile2SelfProfile" {
            let vc = segue.destination as! SelfProfileViewController
            vc.delayImageSelfProfile = delayImageEditProfile
        }
    }
    
    // ACTION: this button will delete a user's account. when pressed, an alert appears asking if the user is sure they want to delete their account. if they are sure, the account will delete from "Authentication" (login auth), "Database" (user data), and "Storage" (profile picture). those three sections of Firebase are the three areas we hold user information. once a user deletes their account there is no way of retrieving the data.
    @IBAction func btnDeleteAccount(_ sender: Any) {
        
        // ALERT: pop up asking user if they are sure they would like to delete their account
        let alertController = UIAlertController(title: "Wait!", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        
        // delete btn in alert (variable). "destructive" style makes it red.
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive,
         
        //action when btn is selected
        handler: { action in
            let user = Auth.auth().currentUser
            print(user)
            user!.delete { error in }
                //poorly done check^, but if code is written correctly, this should be ok... this is supposed to check if user is deleted from "Authentication" section of Firebase. whether or not this works, user will be deleted from db, profile pic will be deleted, and segue to login vc will still happen. if Auth deletion fails, their should be an error alert. Fix later!
            
                    // remove user from database
                    Database.database().reference().child("USERS/\(self.uid!)").removeValue()
                    
                    // delete user profile picture
                    self.storageRef.child("imgProfilePictures/\(self.uid!).png").delete()
            
                    // this is to ensure user is logged out --> this prevents autologin after segue
                        do {
                            try Auth.auth().signOut()
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
            
                    // segue to login vc
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                    self.present(vc!, animated: true, completion: nil)
        })
        
        // cancel btn in alert (variable)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        { (result: UIAlertAction) -> Void in
        }
        
        // create buttons using varibles above
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // sent to the view controller when the app receives a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
