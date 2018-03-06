//
//  AddDeleteClubsOrgsViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 1/30/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class AddDeleteClubsOrgsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet weak var switchClubsOrgs: UISwitch!
    
    //MARK: Properties
    let ref = Database.database()
    let cellId = "AddDeleteClubsOrgsCell"
    let uid = Auth.auth().currentUser?.uid
    
    //this is to load ALL clubsOrgs to the tableView
    var clubsOrgs: [clubsOrgsStruct] = []
    var clubsOrgsAddDelete = clubsOrgsStruct()
    
    //this is used to set checkmarks with data from to send clubsorgs from AddDelete to EditProfile
    var userClubsOrgs: [userClubsOrgsStruct] = []
    var userClubsOrgsAddDelete = userClubsOrgsStruct()
    
    //saving clubs orgs. this is used to send checkmarked data to send clubsorgs from AddDelete to EditProfile
    var saveClubsOrgs: [saveClubsOrgsStruct] = []
    var saveClubsOrgsAddDelete = saveClubsOrgsStruct()
    



    override func viewDidLoad() {
        
        ref.reference(withPath: "LISTS/clubsOrgs").queryOrdered(byChild:"clubsOrgsName").observe(.value, with:
            { snapshot in
                
                var fireAccountArray: [clubsOrgsStruct] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = clubsOrgsStruct(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                }
                
                self.clubsOrgs = fireAccountArray

                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
        })
        
        
        //TODO - load checkmarks for clubs the user has saved
//        ref.reference(withPath:"USERS/\(uid!)/clubsOrgs/").queryOrdered(byChild:"clubsOrgsName").observe(.value, with:
//            { snapshot in
//
//                var fireAccountArrayUSERS: [clubsOrgsStruct] = []
//
//                for fireAccountUSERS in snapshot.children {
//                    let fireAccountUSERS = clubsOrgsStruct(snapshot: fireAccountUSERS as! DataSnapshot)
//                    fireAccountArrayUSERS.append(fireAccountUSERS)
//                }
//
//                self.clubsOrgs = fireAccountArrayUSERS
//
//                self.tableView.delegate = self
//                self.tableView.dataSource = self
//                self.tableView.reloadData()
//
//        })
        
        super.viewDidLoad()

        
    }
    
    //table view - clubsOrgs
    //number of sections (columns??)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubsOrgs.count
    }

    //What is in each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! AddDeleteClubsOrgsTableViewCell
        let clubOrgInfo = self.clubsOrgs[indexPath.row]
        
        var clubOrgName = clubOrgInfo.clubsOrgsName
        var clubOrgId = clubOrgInfo.clubsOrgsId

        //Display club / org
        cell.lblClubsOrgs?.text = clubOrgName
        
        //create array with ALL clubs orgs
        ref.reference(withPath: "USERS/clubsOrgs").observe(.value, with:
            { snapshot in
                if let dictionary = snapshot.value as? [String: Any]
                {
                var fireAccountArray: [clubsOrgsStruct] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = clubsOrgsStruct(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                }
                
                
                var clubsOrgsName = (dictionary["clubsOrgsName"] as? String)!

                  //set checkmarks and variables
                  //let checkmark =
                
                self.clubsOrgs = fireAccountArray
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                }
        })
        
        //create array with USER clubs orgs
        ref.reference(withPath: "USERS/(\(uid!))/clubsOrgs").observe(.value, with:
            { snapshot in
                if let dictionary = snapshot.value as? [String: Any]
                {
                    var fireAccountArray: [userClubsOrgsStruct] = []
                    
                    for fireAccount in snapshot.children {
                        let fireAccount = userClubsOrgsStruct(snapshot: fireAccount as! DataSnapshot)
                        fireAccountArray.append(fireAccount)
                    }
                    
                    
                    var clubsOrgsName = (dictionary["clubsOrgsName"] as? String)!
                    
                    self.userClubsOrgs = fireAccountArray
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }
        })
        
        //below was a test that showed using an array and contains we can toggle the switches for each cell depending if the user has save the club in Firebase
            //var arrayTest = ["Kappa Sigma", "Midnight Run"]
            //if arrayTest.contains(clubOrgName) == true {
        
        clubsOrgs.forEach {_ in
            //TODO - turn switch on if clubsOrgs contains value from userClubsOrgs
            if clubOrgName == "Kappa Sigma" {
                cell.switchClubsOrgs.setOn(true, animated: false)
            }
        }
        
        return cell

    }
    
    var clubsOrgsName:String = " "
    var clubsOrgsId:String = " "
    
    //What happens if you select a row
    //add checkmarks (youtu.be/5MZ-WJuSdpg)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    
        
//        clubsOrgsId = self.clubsOrgs[indexPath.row].clubsOrgsId
//        clubsOrgsName = self.clubsOrgs[indexPath.row].clubsOrgsName
//
//        selectedClubsOrgs = clubsOrgsStruct(clubsOrgsName: clubsOrgsName, clubsOrgsId: clubsOrgsId)
//
//        performSegue(withIdentifier: "saveClubsOrgs", sender: self)
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveClubsOrgs" {
            let vc = segue.destination as! EditProfileViewController
            vc.saveClubsOrgsEditProfile = saveClubsOrgsAddDelete
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
