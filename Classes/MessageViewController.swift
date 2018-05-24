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
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:290),animated: true)
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:0),animated: true)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.autocorrectionType = .yes
        textField.autocapitalizationType = .sentences
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewWillAppearFunc()
    }
        func viewWillAppearFunc() {
        
        //hide table view lines
        self.tableView.separatorStyle = .none
        
        //release keyboard when non-keyboard area of screen is tapped
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
                var fullNameIf = (dictionary["firstName"] as? String)! + " " + (dictionary["lastName"] as? String)!
                self.lblNavBarTitle!.text = fullNameIf
            }
            else {
                var fullNameElse = ""
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

        

        tableView.estimatedRowHeight = 1000
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    @IBAction func btnSendAction(_ sender: Any) {
//        do {
//            try btnSendFunc()
//        }
//        catch {
//            let alertController = UIAlertController(title: "Error!", message: "Looks like something is wrong in our database. Either delete the current conversation by swiping left on the other user's name in the conversations list and start a new one or email MUnchMatesHelpDesk@gmail.com and we will help!", preferredStyle: UIAlertControllerStyle.alert)
//            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
//            }
//            alertController.addAction(okAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
//    func btnSendFunc() {

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
        
                var ampmString:String = ""
                    if hour >= 0 && hour < 12 {
                        ampmString = "AM"
                    }
                    else {
                        ampmString = "PM"
                    }
        
                 let month = calendar.component(.month, from:date)
                 let day = calendar.component(.day, from:date)
                 let year = calendar.component(.year, from:date)
         
                 let dateTime = "\(month).\(day).\(year) • \(hourString):\(minuteString)\(ampmString)"
 

                //change ref to point to correct conversation

                
                let senderRef = Constants.refs.databaseRoot.child("USERS/\(uidSelf!)/conversations/messageList/\(conversationID)/messages/").childByAutoId()
                let senderMessage = ["sender_id": senderId, "name": senderDisplayName, "text": text, "dateTime":dateTime,"timeStamp":timeStampPos] as [String : Any]
                senderRef.setValue(senderMessage)
        
                let receiverRef = Constants.refs.databaseRoot.child("USERS/\(conversationID)/conversations/messageList/\(uidSelf!)/messages/").childByAutoId()
                let receiverMessage = ["sender_id": senderId, "name": senderDisplayName, "text": text, "dateTime":dateTime,"timeStamp":timeStampPos] as [String : Any]
                receiverRef.setValue(receiverMessage)
        
                let ref = Constants.refs.databaseRoot.child("USERS/\(uidSelf!)/conversations/senderList/\(conversationID)")
                let toUserIDValue = ["uid": conversationID, "userDisplayName": self.toUser.firstName + " " + self.toUser.lastName,"timeStamp":timeStampNeg,"read":readTrue] as [String : Any]
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
        
                self.textField.text = nil
        
        //send email notification if enabled
        Database.database().reference().child("USERS/\(conversationID)/").observe(.value, with: { snapshot in
            // get the entire snapshot dictionary
            if let dictionary = snapshot.value as? [String: Any]
            {
                var email = (dictionary["email"] as? String)!
                var emailNotifications = (dictionary["emailNotifications"] as! Bool)
                var timeStampPosCurrent = NSDate().timeIntervalSince1970 - 1.00

                print("timeStampPos: \(timeStampPos) -- timeStampPosCurrent: \(timeStampPosCurrent)")
                if  emailNotifications == true && timeStampPos >= timeStampPosCurrent {
                    print("*************\(emailNotifications) this SHOULD send an email")
                    let smtpSession = MCOSMTPSession()
                    smtpSession.hostname = "smtp.gmail.com"
                    smtpSession.username = "MUnchMatesHelpDesk@gmail.com"
                    smtpSession.password = "vcjSqrL6eBevXsV!"
                    smtpSession.port = 465
                    smtpSession.authType = MCOAuthType.saslPlain
                    smtpSession.connectionType = MCOConnectionType.TLS
                    smtpSession.connectionLogger = {(connectionID, type, data) in
                        if data != nil {
                            if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                                NSLog("Connectionlogger: \(string)")
                            }
                        }
                    }
                    let builder = MCOMessageBuilder()
                    builder.header.to = [MCOAddress(displayName: "MUnchMates User", mailbox: email)]
                    builder.header.from = MCOAddress(displayName: "MUnchMates", mailbox: "MUnchMatesHelpDesk@gmail.com")
                    builder.header.subject = "New MUnchMates Message from \(senderDisplayName!)!"
                    let emailFont = "arial"
                            builder.htmlBody="<font face=\(emailFont)><p><b>\(senderDisplayName!):</b> \(text!)</p><br><i><p>To disable MUnchMates Message notifications, follow this path within the app:</p></br><p>Home Page → Profile → Edit Profile → Turn off 'Notifications'</p></i></font>"
                    
                    
                    let rfc822Data = builder.data()
                    let sendOperation = smtpSession.sendOperation(with: rfc822Data)
                    sendOperation?.start { (error) -> Void in
                        if (error != nil) {
                            NSLog("Error sending email: \(error)")
                            
                            
                        } else {
                            NSLog("Successfully sent email!")
                        }
                    }
                            }
                    else {
                    print("****\(emailNotifications) - this should not send an email")
                    //do not send email
                    }
            }
        })
        
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
        
        //set variable values
//        if self.messagesArray[indexPath.row].dateTime == nil {
//            performSegue(withIdentifier: "Message2ConversationTable", sender: self)
//            print("****ERROR********")
//        }

        print(self.messagesArray[indexPath.row].dateTime)
        
        let senderName = self.messagesArray[indexPath.row].name
        let text = self.messagesArray[indexPath.row].text
        let dateTime = self.messagesArray[indexPath.row].dateTime
        let sender_id = self.messagesArray[indexPath.row].sender_id
        let timeStamp = self.messagesArray[indexPath.row].timeStamp

        let cell = tableView.dequeueReusableCell(withIdentifier: "message") as! MessageTableViewCell

        
        //assign variable values to labels
        cell.lblSenderName?.text = senderName
        cell.lblText?.text = text
        cell.lblDateTime?.text = dateTime
        
        //highlight cell if current user sent message
        if sender_id == currentUser.uid {
            cell.backgroundColor = UIColor.MUnchMatesGold
        }
        
        return cell
        
    }
    
    /* TODO - delete cell... example in conversations vc
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    } */
    
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
