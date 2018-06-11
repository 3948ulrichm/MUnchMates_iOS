//
//  AddDeleteClubsOrgsViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 1/30/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

// this class / view controller can be accessed by a user when viewing their profile and selecting "Update" next to "Clubs / Organizations".
class AddDeleteClubsOrgsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    // the entire vc is a tableView
    @IBOutlet weak var tableView: UITableView!
    
    // ACTION: on the right side of the nav bar a user can press "add/edit". when this is pressed, the mail app will load an email to "MUnchMates@marquette.edu" with the subject "Add or Edit Club/Org" and will have three prewritten questions for the user to answer. this feature allows users to let us know if a club they are in is missing or is spelled wrong. in the transition documents, there is a workflow overviewing how to update clubs/orgs in the database.
    @IBAction func btnAddEditClubsOrgs(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // configure the fields of the interface
        composeVC.setToRecipients(["MUnchMates@marquette.edu"])
        composeVC.setSubject("Add or Edit Club/Org")
        composeVC.setMessageBody("<b>Would you like to ADD a club/org or EDIT a club/org?</b><br><br><br><b>What is the club/org that you would like to add or edit?</b><br><br><br><b>Additional comments:</b><br><br>", isHTML: true)
        
        // present the view controller modally
        self.present(composeVC, animated: true, completion: nil)
        
        }
        
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    // global variables
    let ref = Database.database()
    let cellId = "AddDeleteClubsOrgsCell"
    let uid = Auth.auth().currentUser?.uid
    
    // this is to load ALL clubsOrgs to the tableView
    var clubsOrgs: [clubsOrgsStruct] = []
    var clubsOrgsAddDelete = clubsOrgsStruct()
    
    // viewDidLoad
    override func viewDidLoad() {
        // load all clubs / orgs from Firebase Database
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
        super.viewDidLoad()
    }
    
    //table view - clubsOrgs
    // how many sections does the table view have (this will create mutilple results. for example, if you return 2 and have five results, ten results will show up with with 1st being the same as the 6th, the 2nd being the same as the 7th, etc.)?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // how many rows?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubsOrgs.count
    }

    // what is displayed in each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! AddDeleteClubsOrgsTableViewCell
        let clubOrgInfo = self.clubsOrgs[indexPath.row]
                
        var clubOrgName = clubOrgInfo.clubsOrgsName
        var clubOrgId = clubOrgInfo.clubsOrgsId

        // display club / org
        cell.lblClubsOrgs?.text = clubOrgName
        cell.cellClubOrgId = clubOrgId
        
        Database.database().reference().child("USERS/\(uid!)/clubsOrgs/\(clubOrgId)/clubsOrgsId/").observeSingleEvent(of: .value, with: { snapshot in
            
            // this checks if the user has the clubsOrgsId under their node in the Database. if so, the switch will load ON. if not, it will load OFF.
            if snapshot.exists() && cell.cellClubOrgId == clubOrgId {
                cell.switchClubsOrgs.setOn(true, animated: false)
            }
            else {
                cell.switchClubsOrgs.setOn(false, animated: false)
            }
        })
        return cell
    }
    
    // what happens if you select a row? nothing in this case. in the future, i think it would be very cool to have clubsOrgs pages that have a discription for each club and a list of people in the club. when you select a club on a user's profile, it will take you to this clubsOrgs overview page. work on an Android app first, but down the road, this could be a powerful idea for the app!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        }
    
    // sent to the view controller when the app receives a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
