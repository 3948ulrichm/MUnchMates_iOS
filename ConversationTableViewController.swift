//
//  ConversationTableViewController.swift
//  MUnchMates
//
//  Created by Andrew Webber on 3/8/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class ConversationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func btnHomewardBound(_ sender: Any) {
        performSegue(withIdentifier: "Conversation2Filter", sender: self)
    }
    
    var user: User!
    var userArray: [UserInConversations] = []
    var userConversations = UserInConversations()
    var currentUser = Auth.auth().currentUser!
    let uid = Auth.auth().currentUser?.uid
    var toUserUID: String?
    var toUserDisplayName: String?
    
    
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
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
        })
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "users") as! ConversationTableViewCell
        let userName = self.userArray[indexPath.row].userDisplayName
        cell.lblName?.text = userName
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            //let deleteRef = Database.database().reference(withPath: "debits/\(currentUser.uid)")
//            let userItem = userArray[indexPath.row]
//            userItem.ref?.removeValue()
//        }
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toUserUID = self.userArray[indexPath.row].uid
        toUserDisplayName = self.userArray[indexPath.row].userDisplayName
        userConversations = UserInConversations(uid: toUserUID!, userDisplayName: toUserDisplayName!)
        performSegue(withIdentifier: "Conversation2Message", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Conversation2Message" {
            let vc = segue.destination as! MessageViewController
//            vc.toUser = SearchUsers
            vc.fromUserMessage = userConversations
        }
        if segue.identifier == "Conversation2Filter" {
            _ = segue.destination as! FilterViewController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
