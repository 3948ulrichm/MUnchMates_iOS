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
    var selectedClubsOrgs = clubsOrgsStruct()
    let uid = Auth.auth().currentUser?.uid

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
        
        
        //TODO - load checkmarks for clubs the user has saved
//        ref.reference(withPath:"USERS/\(uid!)/clubsOrgs/").queryOrdered(byChild:"cname").observe(.value, with:
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
        
        //Display club / org
        cell.lblClubsOrgs?.text = clubOrgInfo.cname
        
        return cell

    //TODO - DISPLAY CHECKMARKS IF USER IS IN CLUB
    
    }
    
    var cname:String = " "
    var cid:String = " "
    
    //What happens if you select a row
    //add checkmarks (youtu.be/5MZ-WJuSdpg)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
//            }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
//        }
        
        cid = self.clubsOrgs[indexPath.row].cid
        cname = self.clubsOrgs[indexPath.row].cname
        
        selectedClubsOrgs = clubsOrgsStruct(cname: cname, cid: cid)
        
        performSegue(withIdentifier: "saveClubsOrgs", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveClubsOrgs" {
            let vc = segue.destination as! EditProfileViewController
            vc.clubsOrgsDetails = selectedClubsOrgs
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
