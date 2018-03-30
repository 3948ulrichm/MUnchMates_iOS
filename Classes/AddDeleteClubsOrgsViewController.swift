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

class AddDeleteClubsOrgsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func btnAddEditClubsOrgs(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["MUnchMatesHelpDesk@gmail.com"])
        composeVC.setSubject("Add or Edit Club/Org")
        composeVC.setMessageBody("<b>Would you like to add or edit a club/org?</b><br><br><br><b>What is the club/org you would like to add or edit?</b><br><br><br><b>Additional comments:</b><br><br>", isHTML: true)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
        
        }
        
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
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
        
        

        
        super.viewDidLoad()
        
//        let jsonUrlString = "https://munch-mates-marquette.firebaseio.com/"
//        guard let url = URL(string: jsonUrlString) else { return }
//        URLSession.shared.dataTask(with: url) { (data, response, err) in
//            guard let data = data else { return }
//
//            do {
//                let usersClubsOrgsNames = try JSONDecoder().decode([clubsOrgsStruct].self, from: data)
//            } catch let jsonErr {
//                print("Error serializing json:", jsonErr)
//            }
//            }.resume()

        
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
        cell.cellClubOrgId = clubOrgId
        
        Database.database().reference().child("USERS/\(uid!)/clubsOrgs/\(clubOrgId)/clubsOrgsId/").observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() && cell.cellClubOrgId == clubOrgId {
                cell.switchClubsOrgs.setOn(true, animated: false)
            }
            else {
                cell.switchClubsOrgs.setOn(false, animated: false)
            }
        })

        
        return cell

    }
    
    
    //What happens if you select a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveClubsOrgs" {
            let vc = segue.destination as! SelfProfileViewController
            //vc.saveClubsOrgsEditProfile = saveClubsOrgsAddDelete
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
