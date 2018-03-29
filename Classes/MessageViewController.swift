//
//  MessageViewController.swift
//  MUnchMates
//
//  Created by Andrew Webber on 12/20/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase


class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNavBarTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var chatBarView: UIView!
    
    @IBOutlet weak var constraintChatBarViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var btnSend: UIButton!
    
    var user: User!
    var messagesArray: [messagesStruct] = []
    //var messageArray: [messagesStruct] = []
    //var countUnreadMessages: [UserInConversations] = []
    //var fromUserConversation = UserInConversations()
    var currentUser = Auth.auth().currentUser!
    let uidSelf = Auth.auth().currentUser?.uid
    var uidElse: String?
    //var toUserDisplayName: String?
    //var toUserRead: Bool?
    //var toUserTimeStamp: Double?
    //var userDetailsConversation = SearchUsers()
    
    //get information from conversations / profile VCs
    var toUser = SearchUsers()
    var fromUserMessage = UserInConversations()
    
    
    //text field and send button
    //var messages: [Message]?

    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:250),animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:0),animated: true)
    }
    

    
    override func viewDidLoad() {

        
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //hide table view lines
        self.tableView.separatorStyle = .none
        self.hideKeyboardWhenTappedAround()
        
        //local variables
        //var userDisplayName:String = fromUserMessage.userDisplayName
        var conversationID: String = toUser.uid //this is the other person's uid
        
        //mark message read
        Database.database().reference().child("USERS/\(uidSelf!)/conversations/senderList/\(conversationID)/read").observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                Database.database().reference().child("USERS/\(self.uidSelf!)/conversations/senderList/\(conversationID)/read").setValue(true)
            }
            else {
                //Nothing
            }
        })
        
        //set nav bar title
        Database.database().reference().child("USERS/\(conversationID)/").observe(.value, with: { snapshot in
            // get the entire snapshot dictionary
            if let dictionary = snapshot.value as? [String: Any]
            {
                var fullNameElse = (dictionary["firstName"] as? String)! + " " + (dictionary["lastName"] as? String)!
                self.lblNavBarTitle!.text = fullNameElse
            }
        })
        
        //load messages
        Constants.refs.databaseRoot.child("USERS/\(uidSelf!)/conversations/messageList/\(conversationID)/messages").queryOrdered(byChild:"timeStamp").observe(.value, with:
            { snapshot in
                var fireAccountArray: [messagesStruct] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = messagesStruct(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                }
                
                self.messagesArray = fireAccountArray
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
        })
        

        
        print(messagesArray.count)
    
        tableView.estimatedRowHeight = 1000
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //this disables / enables btn based on if there is text in the field
//        if textField.text != nil {
//            btnSend.isEnabled = true
//            //CHANGE COLOR TO GRAY
//            //btnSend.currentTitleColor = .gray
//        }
//        else {
//            btnSend.isEnabled = false
//        }
        
    }
    
    
    @IBAction func btnSendAction(_ sender: Any) {
                var conversationID: String = toUser.uid
                var userDisplayName:String = fromUserMessage.userDisplayName
                var timeStampPos = NSDate().timeIntervalSince1970 //get timestamp
                var timeStampNeg = timeStampPos * -1 //make timestamp negative to order the users in decending order in ConversationViewController
                var timeStampNegString = String(timeStampNeg)
                var readFalse = false
                var readTrue = true
                var senderId = uidSelf!
                var senderDisplayName = Auth.auth().currentUser?.displayName
                var text = textField.text
        
                //date time variable
                 let date = Date()
                 let calendar = Calendar.current
         
                 let hour = calendar.component(.hour, from:date)
                 let minute = calendar.component(.minute, from:date)
                 let second = calendar.component(.second, from:date)
         
                 let month = calendar.component(.month, from:date)
                 let day = calendar.component(.day, from:date)
                 let year = calendar.component(.year, from:date)
         
                 let dateTime = "\(month).\(day).\(year) • \(hour):\(minute)"
 

                //change ref to point to correct conversation
                let senderRef = Constants.refs.databaseRoot.child("USERS/\(uidSelf!)/conversations/messageList/\(conversationID)/messages/").childByAutoId()
                let senderMessage = ["sender_id": senderId, "name": senderDisplayName, "text": text, "dateTime":dateTime,"timeStamp":timeStampNeg] as [String : Any]
                senderRef.setValue(senderMessage)
        
                let receiverRef = Constants.refs.databaseRoot.child("USERS/\(conversationID)/conversations/messageList/\(uidSelf!)/messages/").childByAutoId()
                let receiverMessage = ["sender_id": senderId, "name": senderDisplayName, "text": text, "dateTime":dateTime,"timeStamp":timeStampNeg] as [String : Any]
                receiverRef.setValue(receiverMessage)
        
                let ref = Constants.refs.databaseRoot.child("USERS/\(uidSelf!)/conversations/senderList/\(conversationID)")
                let toUserIDValue = ["uid": conversationID, "userDisplayName": toUser.firstName + " " + toUser.lastName,"timeStamp":timeStampNeg,"read":readTrue] as [String : Any]
                ref.setValue(toUserIDValue)
        
                let ref2 = Constants.refs.databaseRoot.child("USERS/\(conversationID)/conversations/senderList/\(uidSelf!)")
                let fromUserIDValue = ["uid": uidSelf!, "userDisplayName": userDisplayName,"timeStamp":timeStampNeg,"read":readFalse] as [String : Any]
                ref2.setValue(fromUserIDValue)
        
                //count messages in convo and delete if over 20 - SENDING (current) USER
                Constants.refs.databaseRoot.child("USERS/\(uidSelf!)/conversations/messageList/\(conversationID)/messages/").observe(.value, with:
                    { snapshot in
                        var fireAccountArray: [messagesStruct] = []

                        for fireAccount in snapshot.children {
                            let fireAccount = messagesStruct(snapshot: fireAccount as! DataSnapshot)
                            fireAccountArray.append(fireAccount)
                        }

                        self.messagesArray = fireAccountArray

                        if self.messagesArray.count > 20 {
                            var oldestMessage = self.messagesArray[0]
                            var oldestMessageRef = String(describing: oldestMessage.ref!)
                            if oldestMessageRef.contains("/messages/") {
                                let endIndex = oldestMessageRef.range(of: "/messages/")!.upperBound
                                print("endIndex \(endIndex)")

                                var nodeToDelete = oldestMessageRef.substring(from: endIndex).trimmingCharacters(in: .whitespacesAndNewlines)

                                Constants.refs.databaseRoot.child("USERS/\(self.uidSelf!)/conversations/messageList/\(conversationID)/messages/\(nodeToDelete)").removeValue()
                            }
                        }
                })

                //count messages in convo and delete if over 20 - RECEIVING USER
                Constants.refs.databaseRoot.child("USERS/\(conversationID)/conversations/messageList/\(uidSelf!)/messages/").observe(.value, with:
                    { snapshot in
                        var fireAccountArray: [messagesStruct] = []

                        for fireAccount in snapshot.children {
                            let fireAccount = messagesStruct(snapshot: fireAccount as! DataSnapshot)
                            fireAccountArray.append(fireAccount)
                        }

                        self.messagesArray = fireAccountArray

                        if self.messagesArray.count > 20 {
                            var oldestMessage = self.messagesArray[0]
                            var oldestMessageRef = String(describing: oldestMessage.ref!)
                            if oldestMessageRef.contains("/messages/") {
                                let endIndex = oldestMessageRef.range(of: "/messages/")!.upperBound
                                print("endIndex \(endIndex)")

                                var nodeToDelete = oldestMessageRef.substring(from: endIndex).trimmingCharacters(in: .whitespacesAndNewlines)

                                Constants.refs.databaseRoot.child("USERS/\(conversationID)/conversations/messageList/\(self.uidSelf!)/messages/\(nodeToDelete)").removeValue()
                            }
                        }
                })
        
        textField.text = nil
    }
    
    
    //nav bar buttons
    @IBAction func btnMessages(_ sender: Any) {
        performSegue(withIdentifier: "Message2ConversationTable", sender: self)
    }
    
    
    @IBAction func btnProfile(_ sender: Any) {
        performSegue(withIdentifier: "Message2Profile", sender: self)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    //what is displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message") as! MessageTableViewCell
        
        //flip cell and table --> this puts first cell at bottom of tableView
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)

        
        //set variable values
        let senderName = self.messagesArray[indexPath.row].name
        let text = self.messagesArray[indexPath.row].text
        let dateTime = self.messagesArray[indexPath.row].dateTime
        
        //assign variable values to labels
        cell.lblSenderName?.text = senderName
        cell.lblText?.text = text
        cell.lblDateTime?.text = dateTime
        
        return cell
        
    }
    
    /*
     TODO - delete cell... example in conversations vc
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    */
    
    //what happens when cell is pressed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Message2Profile" {
            let vc = segue.destination as! ProfileMessageViewController
            vc.fromMessageToProfile = toUser
            vc.fromUserMessageProfile = fromUserMessage
        }
    }
    
}



///////ADD THIS TO SEND BUTTON
/*
let date = Date()
let calendar = Calendar.current

let hour = calendar.component(.hour, from:date)
let minute = calendar.component(.minute, from:date)
let second = calendar.component(.second, from:date)

let month = calendar.component(.month, from:date)
let day = calendar.component(.day, from:date)
let year = calendar.component(.year, from:date)

let dateTime = "\(month).\(day).\(year)  \(hour):\(minute):\(second)"
*/
