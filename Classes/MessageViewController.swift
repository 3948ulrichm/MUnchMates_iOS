//
//  MessageViewController.swift
//  MUnchMates
//
//  Created by Andrew Webber on 12/20/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

// this class / view controller is used for users can have one and one chats with each other
class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNavBarTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var scrollView: UIScrollView! // scroll view is used to move the table view, textbox, and send button up when the keyboard lifts up.
    
    // structs
    // this is used to display messages of the conversation in the table view
    var messagesArray: [messagesStruct] = []
    
    // global variables
    var user: User!

    var currentUser = Auth.auth().currentUser!
    let uidSelf = Auth.auth().currentUser?.uid
    var uidElse: String? // this will be the uid for the user the current user is having a conversation with

    var toUser = SearchUsers() // stores information of user that the current user is having a conversation with
    var fromUserMessage = UserInConversations() // stores information of current user
    
    // IMPORTANT: when user selects textbox and the keyboard comes up, the textbox and send button are raised 290 pixels (or whatever the messurement is in). ideally, this will be the height of the keyboard, but I could not figure out how to get the height of the keyboard. currently, 290 raises the textbox and send button high enough on every ios device but as apple creates new ios devices, this number may have to be changed. in the future, if we can figure out how to raise the textbox and send button to be the height of the keyboard, that would solve this issue!
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:290),animated: true) // if we can get the exact height of the keyboard, change "290" to that number.
    }

    // height of textbox and send button when keyboard is down. this will stay constant.
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:0),animated: true)
    }
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // autocorrect is on and first letter of each sentence is capitalized.
        textField.autocorrectionType = .yes
        textField.autocapitalizationType = .sentences
    }
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        // calls viewWillAppearFunc() function. we also could have just put the function inside viewWillAppear. this is just another way of doing it.
        viewWillAppearFunc()
    }
    
    // viewWillAppearFunc() declares what will load on the view controller. this func is called in viewWillAppear.
    func viewWillAppearFunc() {
        
        // hide table view lines
        self.tableView.separatorStyle = .none
        
        // release keyboard when non-keyboard area of screen is tapped
        self.hideKeyboardWhenTappedAround()
        
        // local variables
        var conversationID: String = toUser.uid //this is the other user's uid. the other user's uid serves as the current user's conversationID for that conversation.
        
        // mark message read
        Database.database().reference().child("USERS/\(uidSelf!)/conversations/senderList/\(conversationID)/read").observeSingleEvent(of: .value, with: { snapshot in
            
            // checks if conversation already exists. if not, nothing is sent to the database. this check was added bc when users would click the "message" button in someone's profile, a new node would automatically create, only creating a conversation id string and read bool. this caused the app to crash bc there was no timeStamp and userDisplayName under senderList, which is needed by the conversation table view controller. in order to prevent this issue of created a node without all need data, we created this check. if the current user had not recently had a conversation, there would be no matching conversationID in the file path. if the file path does not currently exist, nothing will get sent to the database. if there is an existing file path, a true bool will get sent to the "read" attribute, indicating that any unread messages have now been read.
            if snapshot.exists() {
                Database.database().reference().child("USERS/\(self.uidSelf!)/conversations/senderList/\(conversationID)/read").setValue(true)
            }
            else {
                // nothing
            }
        })
        
        // set nav bar title
        Database.database().reference().child("USERS/\(conversationID)/").observe(.value, with: { snapshot in
            // get the entire snapshot dictionary
            if let dictionary = snapshot.value as? [String: Any]
            {
                var fullNameIf = (dictionary["firstName"] as? String)! + " " + (dictionary["lastName"] as? String)!
                self.lblNavBarTitle!.text = fullNameIf
            }
            // if first and last name cannot be found in database (which should never happen), nav bar title will be blank.
            else {
                var fullNameElse = ""
                self.lblNavBarTitle!.text = fullNameElse
            }
        })
        
        // load messages. ordered by timeStamp.
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

        tableView.estimatedRowHeight = 1000
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // ACTION: when send button is pressed, data gets sent to Database in current user's conversation node and the recepient user's conversation node.
    @IBAction func btnSendAction(_ sender: Any) {
        
        // local variables
        var conversationID: String = toUser.uid
        var userDisplayName:String = fromUserMessage.userDisplayName
        var timeStampPos = NSDate().timeIntervalSince1970 //get timestamp
        var timeStampNeg = timeStampPos * -1 // make timestamp negative to order the users in decending order in ConversationTableViewController
        var timeStampNegString = String(timeStampNeg)
        var readFalse = false
        var readTrue = true
        var senderId = uidSelf!
        var senderDisplayName = Auth.auth().currentUser?.displayName
        var text = textField.text

        // date time variable
        let date = Date()
        let calendar = Calendar.current
 
        // convert hours from military time to 1-12 am/pm format.
        var hour = calendar.component(.hour, from:date)
        var hourString = String(hour)
            switch hourString {
                case "0":hourString="12"
                case "1":hourString="1"
                case "2":hourString="2"
                case "3":hourString="3"
                case "4":hourString="4"
                case "5":hourString="5"
                case "6":hourString="6"
                case "7":hourString="7"
                case "8":hourString="8"
                case "9":hourString="9"
                case "10":hourString="10"
                case "11":hourString="11"
                case "12":hourString="12"
                case "13":hourString="1"
                case "14":hourString="2"
                case "15":hourString="3"
                case "16":hourString="4"
                case "17":hourString="5"
                case "18":hourString="6"
                case "19":hourString="7"
                case "20":hourString="8"
                case "21":hourString="9"
                case "22":hourString="10"
                case "23":hourString="11"
                default: hourString = "00"
            }
        
        // convert mites from single and double digits to all double digits (i.e. 0 to 00)
        let minute = calendar.component(.minute, from:date)
        var minuteString = String(minute)
            switch minuteString {
                case "0":minuteString="00"
                case "1":minuteString="01"
                case "2":minuteString="02"
                case "3":minuteString="03"
                case "4":minuteString="04"
                case "5":minuteString="05"
                case "6":minuteString="06"
                case "7":minuteString="07"
                case "8":minuteString="08"
                case "9":minuteString="09"
                case "10":minuteString="10"
                case "11":minuteString="11"
                case "12":minuteString="12"
                case "13":minuteString="13"
                case "14":minuteString="14"
                case "15":minuteString="15"
                case "16":minuteString="16"
                case "17":minuteString="17"
                case "18":minuteString="18"
                case "19":minuteString="19"
                case "20":minuteString="20"
                case "21":minuteString="21"
                case "22":minuteString="22"
                case "23":minuteString="23"
                case "24":minuteString="24"
                case "25":minuteString="25"
                case "26":minuteString="26"
                case "27":minuteString="27"
                case "28":minuteString="28"
                case "29":minuteString="29"
                case "30":minuteString="30"
                case "31":minuteString="31"
                case "32":minuteString="32"
                case "33":minuteString="33"
                case "34":minuteString="34"
                case "35":minuteString="35"
                case "36":minuteString="36"
                case "37":minuteString="37"
                case "38":minuteString="38"
                case "39":minuteString="39"
                case "40":minuteString="40"
                case "41":minuteString="41"
                case "42":minuteString="42"
                case "43":minuteString="43"
                case "44":minuteString="44"
                case "45":minuteString="45"
                case "46":minuteString="46"
                case "47":minuteString="47"
                case "48":minuteString="48"
                case "49":minuteString="49"
                case "50":minuteString="50"
                case "51":minuteString="51"
                case "52":minuteString="52"
                case "53":minuteString="53"
                case "54":minuteString="54"
                case "55":minuteString="55"
                case "56":minuteString="56"
                case "57":minuteString="57"
                case "58":minuteString="58"
                case "59":minuteString="59"
                default: minuteString="00"
            }

        // if hour is 0 to 11, code will use AM. otherwise, code will use PM.
        var ampmString:String = ""
            if hour >= 0 && hour < 12 {
                ampmString = "AM"
            }
            else {
                ampmString = "PM"
            }
        
        // date variables
        let month = calendar.component(.month, from:date)
        let day = calendar.component(.day, from:date)
        let year = calendar.component(.year, from:date)
 
        // using date and time variables, create string that will be saved in Database as dateTime
        let dateTime = "\(month).\(day).\(year) • \(hourString):\(minuteString)\(ampmString)"

        // update current user's Database with new message that was sent
        let senderRef = Constants.refs.databaseRoot.child("USERS/\(uidSelf!)/conversations/messageList/\(conversationID)/messages/").childByAutoId()
        let senderMessage = ["sender_id": senderId, "name": senderDisplayName, "text": text, "dateTime":dateTime,"timeStamp":timeStampPos] as [String : Any]
        senderRef.setValue(senderMessage)

        // update recepient user's Database with new message that was sent
        let receiverRef = Constants.refs.databaseRoot.child("USERS/\(conversationID)/conversations/messageList/\(uidSelf!)/messages/").childByAutoId()
        let receiverMessage = ["sender_id": senderId, "name": senderDisplayName, "text": text, "dateTime":dateTime,"timeStamp":timeStampPos] as [String : Any]
        receiverRef.setValue(receiverMessage)

        // update current user's senderList node with new timeStamp
        let ref = Constants.refs.databaseRoot.child("USERS/\(uidSelf!)/conversations/senderList/\(conversationID)")
        let toUserIDValue = ["uid": conversationID, "userDisplayName": self.toUser.firstName + " " + self.toUser.lastName,"timeStamp":timeStampNeg,"read":readTrue] as [String : Any]
        ref.setValue(toUserIDValue)

        // update recepient user's senderList node with new timeStamp and change "read" bool to false
        let ref2 = Constants.refs.databaseRoot.child("USERS/\(conversationID)/conversations/senderList/\(uidSelf!)")
        let fromUserIDValue = ["uid": uidSelf!, "userDisplayName": userDisplayName,"timeStamp":timeStampNeg,"read":readFalse] as [String : Any]
        ref2.setValue(fromUserIDValue)

        // count messages in convo and delete if over 20 - SENDING (current) USER. i.e. when 21st message is sent, the 1st message in conversation is deleted. we added this feature for two reasons. one, we don't want people to have long conversations with each other. we want them to meet up in person instead. two, this will save space in our Database if user's are having long conversations.
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

        // count messages in convo and delete if over 20 - RECEIVING USER. i.e. when 21st message is sent, the 1st message in conversation is deleted. we added this feature for two reasons. one, we don't want people to have long conversations with each other. we want them to meet up in person instead. two, this will save space in our Database if user's are having long conversations.
        Constants.refs.databaseRoot.child("USERS/\(conversationID)/conversations/messageList/\(self.uidSelf!)/messages/").observe(.value, with:
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
        
        // after message is send, make textfield blank
        self.textField.text = nil
    }
    
    // nav bar buttons
    // ACTION: this will take the current user to their conversation table vc
    @IBAction func btnMessages(_ sender: Any) {
        performSegue(withIdentifier: "Message2ConversationTable", sender: self)
    }
    
    // ACTION: this will display the profile of the user that the current user is having a conversation with. when pressed, data about current user and other user are passed through to profile message vc.
    @IBAction func btnProfile(_ sender: Any) {
        performSegue(withIdentifier: "Message2Profile", sender: self)
    }
    
    // TABLE VIEW
    // how many sections does the table view have (this will create mutilple results. for example, if you return 2 and have five results, ten results will show up with with 1st being the same as the 6th, the 2nd being the same as the 7th, etc.)?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // how many rows?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    // what is displayed in each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // local variables
        let senderName = self.messagesArray[indexPath.row].name
        let text = self.messagesArray[indexPath.row].text
        let dateTime = self.messagesArray[indexPath.row].dateTime
        let sender_id = self.messagesArray[indexPath.row].sender_id
        let timeStamp = self.messagesArray[indexPath.row].timeStamp

        let cell = tableView.dequeueReusableCell(withIdentifier: "message") as! MessageTableViewCell

        
        // assign variable values to labels
        cell.lblSenderName?.text = senderName
        cell.lblText?.text = text
        cell.lblDateTime?.text = dateTime
        
        // highlight cell MUnchMatesGold if current user sent message
        if sender_id == currentUser.uid {
            cell.backgroundColor = UIColor.MUnchMatesGold
        }
        
        return cell
    }
    
    /* TODO - delete cell... example in conversations vc
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    } */
    
    // what happens when cell is pressed? nothing as of now.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // segue to profile message vc. passes data about current user and other user in conversation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Message2Profile" {
            let vc = segue.destination as! ProfileMessageViewController
            vc.fromMessageToProfile = toUser
            vc.fromUserMessageProfile = fromUserMessage
        }
    }
    
    // sent to the view controller when the app receives a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
