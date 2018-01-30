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
    var clubsOrgs: [clubsOrgsStruct] = []
    let uid = Auth.auth().currentUser?.uid
    var selectedClubOrg = clubsOrgsStruct()

    override func viewDidLoad() {
        
        ref.reference(withPath: "CLUBSORGS/").queryOrdered(byChild:"cname").observe(.value, with:
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubsOrgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! AddDeleteClubsOrgsTableViewCell
        let clubOrgInfo = self.clubsOrgs[indexPath.row]
        
        //Display club / org
        cell.lblClubsOrgs?.text = clubOrgInfo.cname
        return cell
        
    }
    
    var cname:String = ""
    
    //added by awebber to add c
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cname = self.clubsOrgs[indexPath.row].cname
        
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
