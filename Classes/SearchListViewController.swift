//
//  SearchListViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 12/13/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class SearchListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let ref = Database.database()
    let cellId = "SearchListCell"
    var users: [SearchUsers] = []
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
    
        
        ref.reference(withPath: "USERS/").queryOrdered(byChild:"firstName").observe(.value, with:
            { snapshot in
                var fireAccountArray: [SearchUsers] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = SearchUsers(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                    
                }
                
                self.users = fireAccountArray
                
                self.tableView.delegate = self;
                self.tableView.dataSource = self;
                self.tableView.reloadData()
        })
        
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! SearchListTableViewCell
        let userinfo = self.users[indexPath.row]
        cell.lblNameSearchList?.text = userinfo.firstName + " " + userinfo.lastName
        
        return cell
        
    }
}
