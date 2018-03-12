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
    var fromUserConversation = UserInConversations()
    var currentUser = Auth.auth().currentUser!
    let uid = Auth.auth().currentUser?.uid
    var toUserUID: String?
    var toUserDisplayName: String?
    var toUserRead: Bool?
    var toUserTimeStamp: Double?
    var userDetailsConversation = SearchUsers()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations/senderList").queryOrdered(byChild:"timeStamp").observe(.value, with:
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
        let userUid = self.userArray[indexPath.row].uid
        let userRead = self.userArray[indexPath.row].read
        
        if userRead == false {
            cell.lblName?.font = UIFont.boldSystemFont(ofSize: 17.0)
            cell.lblName?.text = userName
            cell.lblUnread?.text = ""
        }
        else {
            cell.lblName?.font = UIFont.systemFont(ofSize: 17.0)
            cell.lblName?.text = userName
            cell.lblUnread?.text = ""
        }
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            //let deleteRef = Database.database().reference(withPath: "debits/\(currentUser.uid)")
//            let userItem = userArray[indexPath.row]
//            userItem.ref?.removeValue()
//        }
//    }

    var firstName = ""
    var lastName = ""
    var mealPlan = false
    var mateType = ""
    var college = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Else user information
        toUserUID = self.userArray[indexPath.row].uid
        toUserDisplayName = self.userArray[indexPath.row].userDisplayName
        toUserRead = self.userArray[indexPath.row].read
        toUserTimeStamp = self.userArray[indexPath.row].timeStamp
        
        userDetailsConversation = SearchUsers(firstName: toUserDisplayName!, lastName: lastName, mealPlan: mealPlan, mateType: mateType, college: college, uid: toUserUID!)

        
        //Self user information
        var selfUid = Auth.auth().currentUser?.uid
        var selfName = Auth.auth().currentUser?.displayName
        
        fromUserConversation = UserInConversations(read:toUserRead!, timeStamp:toUserTimeStamp!, uid: selfUid!, userDisplayName: selfName!)
        
        performSegue(withIdentifier: "Conversation2Message", sender: self)
        
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Conversation2Message" {
            let vc = segue.destination as! MessageViewController
            vc.toUser = userDetailsConversation
            vc.fromUserMessage = fromUserConversation
            
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
