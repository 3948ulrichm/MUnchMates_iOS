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
    
    @IBOutlet weak var lblNavBarTitle: UILabel!
    
    @IBAction func btnHomewardBound(_ sender: Any) {
        performSegue(withIdentifier: "Conversation2Filter", sender: self)
    }
    
    var user: User!
    var userArray: [UserInConversations] = []
    var countUnreadMessages: [UserInConversations] = []
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        let read = "read"
        let unread = false
        Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations/senderList/").queryOrdered(byChild:read).queryEqual(toValue: unread).observe(.value, with:
            { snapshot in
                var fireAccountArray: [UserInConversations] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = UserInConversations(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                }
                
                self.countUnreadMessages = fireAccountArray
                
                let unreadMessageCount:Int = self.countUnreadMessages.count
                print("*****\(unreadMessageCount)*********")
                if unreadMessageCount > 0 {
                    self.lblNavBarTitle.text = "Messages (\(unreadMessageCount))"
                }
                else {
                    self.lblNavBarTitle.text = "Messages"                }
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
        //let userUid = self.userArray[indexPath.row].uid
        let userRead = self.userArray[indexPath.row].read
        //let timeStamp = self.userArray[indexPath.row].timeStamp
        
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
    
    //User can delete conversation with another user by swiping on their table cell. This action will only delete the conversation from the current user's database. The conversation will still exist under the other user's conversations node.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        toUserUID = self.userArray[indexPath.row].uid
        
        if editingStyle == UITableViewCellEditingStyle.delete {

        Constants.refs.databaseRoot.child("USERS/\(self.uid!)/conversations/messageList/\(toUserUID!)/").removeValue()
        Constants.refs.databaseRoot.child("USERS/\(self.uid!)/conversations/senderList/\(toUserUID!)/").removeValue()

        }
    }

    var firstName = ""
    var lastName = ""
    var mealPlan = false
    var mateType = ""
    var muteMode = false
    var college = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Else user information
        toUserUID = self.userArray[indexPath.row].uid
        toUserDisplayName = self.userArray[indexPath.row].userDisplayName
        toUserRead = self.userArray[indexPath.row].read
        toUserTimeStamp = self.userArray[indexPath.row].timeStamp
        
        userDetailsConversation = SearchUsers(firstName: toUserDisplayName!, lastName: lastName, mealPlan: mealPlan, mateType: mateType, muteMode:muteMode, college: college, uid: toUserUID!)

        
        //Self user information
        let selfUid = Auth.auth().currentUser?.uid
        let selfName = Auth.auth().currentUser?.displayName
        
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
