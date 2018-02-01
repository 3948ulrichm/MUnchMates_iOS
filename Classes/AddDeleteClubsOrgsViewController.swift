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
    
    //MARK: Properties
    let ref = Database.database()
    let cellId = "AddDeleteClubsOrgsCell"
    var clubsOrgsCLUBSORGS: [clubsOrgsStruct] = []
    var clubsOrgsUSERS: [clubsOrgsStruct] = []
    let uid = Auth.auth().currentUser?.uid
    var selectedClubOrg = clubsOrgsStruct()

    override func viewDidLoad() {
        
        ref.reference(withPath: "CLUBSORGS/").queryOrdered(byChild:"cname").observe(.value, with:
            { snapshot in
                
                var fireAccountArray: [clubsOrgsStruct] = []
                
                for fireAccountCLUBSORGS in snapshot.children {
                    let fireAccountCLUBSORGS = clubsOrgsStruct(snapshot: fireAccountCLUBSORGS as! DataSnapshot)
                    fireAccountArray.append(fireAccountCLUBSORGS)
                }
                
                self.clubsOrgsCLUBSORGS = fireAccountArray

                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
        })
        
        
        //load checkmarks for clubs the user has saved
        ref.reference(withPath:"USERS/\(uid!)/clubsOrgs/").queryOrdered(byChild:"cname").observe(.value, with:
            { snapshot in
                
                var fireAccountArrayUSERS: [clubsOrgsStruct] = []
                
                for fireAccountUSERS in snapshot.children {
                    let fireAccountUSERS = clubsOrgsStruct(snapshot: fireAccountUSERS as! DataSnapshot)
                    fireAccountArrayUSERS.append(fireAccountUSERS)
                }
                
                self.clubsOrgsUSERS = fireAccountArrayUSERS
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                
        })
        
        super.viewDidLoad()

        
    }
    
    //table view - clubsOrgs
    //number of sections (columns??)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubsOrgsCLUBSORGS.count
    }

    
    //What is in each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! AddDeleteClubsOrgsTableViewCell
        let clubOrgInfo = self.clubsOrgsCLUBSORGS[indexPath.row]
        
        //Display club / org
        var lblClubsOrgs = cell.lblClubsOrgs?.text
        lblClubsOrgs = clubOrgInfo.cname
        
        return cell

    //DISPLAY CHECKMARKS IF USER IS IN CLUB
    
    }
    
    var cnameCLUBSORGS:String = ""
    var cnameUSERS:String = ""
    
    //What happens if you select a row
    //add checkmarks (youtu.be/5MZ-WJuSdpg)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
