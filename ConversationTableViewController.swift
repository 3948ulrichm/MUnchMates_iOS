//
//  ConversationTableViewController.swift
//  MUnchMates
//
//  Created by Andrew Webber on 3/8/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

// this class / view controller lists all conversations a user has. the view controller is a table view that lists the full name each person the current user has a conversation with. if a message is unread, the label in the cell will bold and an apple symbol will show up to the left of the name. the cells are ordered with most recent messages (sent or recieved) in conversations at the top, just like a text message app would do.
class ConversationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNavBarTitle: UILabel! // this will change to show how many unread messages there are.
    
    // ACTION: this will take the user to the home page. no data gets passed with this segue.
    @IBAction func btnHomewardBound(_ sender: Any) {
        performSegue(withIdentifier: "Conversation2Filter", sender: self)
    }
    
    // global variables
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
    
    // viewDidLoad
    override func viewDidLoad() {
        // loads array of users that current user has conversations with.
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
        super.viewDidLoad()
    }
    
    // viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        
        let read = "read"
        let unread = false
        
        // gets count of unread messages
        Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations/senderList/").queryOrdered(byChild:read).queryEqual(toValue: unread).observe(.value, with:
            { snapshot in
                var fireAccountArray: [UserInConversations] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = UserInConversations(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                }
                
                self.countUnreadMessages = fireAccountArray
                
                let unreadMessageCount:Int = self.countUnreadMessages.count
                
                // changes title of nav bar if there are unread messages
                if unreadMessageCount > 0 {
                    self.lblNavBarTitle.text = "Messages (\(unreadMessageCount))"
                }
                else {
                    self.lblNavBarTitle.text = "Messages"
                }
        })
    }
    
    // TABLE VIEW
    // how many sections does the table view have (this will create mutilple results. for example, if you return 2 and have five results, ten results will show up with with 1st being the same as the 6th, the 2nd being the same as the 7th, etc.)?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // how many rows?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    // what is displayed in each cell of table view?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "users") as! ConversationTableViewCell
        let userName = self.userArray[indexPath.row].userDisplayName
        let userRead = self.userArray[indexPath.row].read
        
        // if conversation has unread message(s), name label will become bold and an apple symbol will appear
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
    
    // user can delete conversation with another user by swiping on their table cell. This action will only delete the conversation from the current user's database. The conversation will still exist under the other user's conversations node.
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
    
    // what happens when you select a cell?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // user information for person current user has a conversation with
        toUserUID = self.userArray[indexPath.row].uid
        toUserDisplayName = self.userArray[indexPath.row].userDisplayName
        toUserRead = self.userArray[indexPath.row].read
        toUserTimeStamp = self.userArray[indexPath.row].timeStamp
        
        // user information for person current user has a conversation with is put into a struct
        userDetailsConversation = SearchUsers(firstName: toUserDisplayName!, lastName: lastName, mealPlan: mealPlan, mateType: mateType, muteMode:muteMode, college: college, uid: toUserUID!)

        
        // current user information
        let selfUid = Auth.auth().currentUser?.uid
        let selfName = Auth.auth().currentUser?.displayName
        
        // current user information is put into a struct
        fromUserConversation = UserInConversations(read:toUserRead!, timeStamp:toUserTimeStamp!, uid: selfUid!, userDisplayName: selfName!)
        
        // segue from conversation table vc to message vc. this struct passes user information for person current user has a conversation with and current user information
        performSegue(withIdentifier: "Conversation2Message", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // segue from conversation table vc to message vc. this struct passes user information for person current user has a conversation with and current user information
        if segue.identifier == "Conversation2Message" {
            let vc = segue.destination as! MessageViewController
            vc.toUser = userDetailsConversation
            vc.fromUserMessage = fromUserConversation
        }
        
        if segue.identifier == "Conversation2Filter" {
            _ = segue.destination as! FilterViewController
        }
        
    }
    
    // sent to the view controller when the app receives a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
