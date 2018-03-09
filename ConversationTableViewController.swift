//
//  ConversationTableViewController.swift
//  MUnchMates
//
//  Created by Andrew Webber on 3/8/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class ConversationTableViewController: UITableViewController {

    var user: User!
    var userArray: [UserInConversations] = []
    var currentUser = Auth.auth().currentUser!
    let uid = Auth.auth().currentUser?.uid
    var toUser = UserInConversations()
    var toUserUID: String?
    var toUserDisplayName: String?

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "users") as! ConversationTableViewCell
        let user = self.userArray[indexPath.row]
        cell.lblName?.text = user.userDisplayName
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //let deleteRef = Database.database().reference(withPath: "debits/\(currentUser.uid)")
            let userItem = userArray[indexPath.row]
            userItem.ref?.removeValue()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations/senderList").observe(.value, with:
            { snapshot in
                var fireAccountArray: [UserInConversations] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = UserInConversations(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                }

                self.userArray = fireAccountArray
                self.tableView.reloadData()
        })
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toUserUID = self.userArray[indexPath.row].uid
        toUserDisplayName = self.userArray[indexPath.row].userDisplayName
        toUser = UserInConversations(uid: toUserUID!, userDisplayName: toUserDisplayName!)
        performSegue(withIdentifier: "toMessageScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessageScreen" {
            let vc = segue.destination as! MessageViewController
            vc.toUserCon = toUser
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    

}
