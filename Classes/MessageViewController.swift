//
//  MessageViewController.swift
//  MUnchMates
//
//  Created by Andrew Webber on 12/20/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
import CoreFoundation

class MessageViewController: JSQMessagesViewController {
    
    @IBOutlet weak var sidebarViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sideView: UIView!
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBAction func btnMessages(_ sender: Any) {
        performSegue(withIdentifier: "message2conversations", sender: self)
    }

    

    var toUser = SearchUsers()
    var fromUserMessage = UserInConversations()
    
    var messages = [JSQMessage]()
    let uid = Auth.auth().currentUser?.uid
    let user = Auth.auth().currentUser
    let dataRef = Database.database().reference()
    
    var messagesArray: [messagesStruct] = []
    //var messagesArray2 = messagesStruct()
    

    
    
    //bubbles
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.MUnchMatesBlue)
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.MUnchMatesGold)

    }()

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        //for messaging
        let defaults = UserDefaults.standard
        
        var userDisplayName:String = fromUserMessage.userDisplayName
        var conversationID: String = toUser.uid
        
        
        //********TODO- only have this update if user has message
        //MARK MESSAGE AS READ. If message has not been started, initiate values
        
        Database.database().reference().child("USERS/\(uid!)/conversations/senderList/\(conversationID)/read").observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                Database.database().reference().child("USERS/\(self.uid!)/conversations/senderList/\(conversationID)/read").setValue(true)
            }
            else {
                //Nothing
            }
        })


        if  let id = uid
        {
            senderId = id
            senderDisplayName = userDisplayName
        }
        else
        {
            senderId = uid
            senderDisplayName = userDisplayName

            defaults.set(senderId, forKey: "jsq_id")
            //defaults.set(senderDisplayName, forKey: "jsq_id")
            defaults.synchronize()

            showDisplayNameDialog()
        }
        
        
        
//        var title = "\(userDisplayName)"
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDisplayNameDialog))
//        tapGesture.numberOfTapsRequired = 1
//
//        navigationController?.navigationBar.addGestureRecognizer(tapGesture)

        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        if self.inputToolbar.contentView.leftBarButtonItem != nil {
            self.inputToolbar.contentView.leftBarButtonItem.isEnabled = false
        }
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero

        let query = Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations/messageList/\(conversationID)/messages/")

        _ = query .observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                !text.isEmpty
            {
                if let message = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    self?.messages.append(message)
                    
                    self?.finishReceivingMessage()

                }
            }
        })
        
        
        Constants.refs.databaseRoot.child("USERS/\(conversationID)/").observe(.value, with: { snapshot in
                if let dictionary = snapshot.value as? [String: Any]
                {
                    var fullName = (dictionary["firstName"] as? String)! + " " + (dictionary["lastName"] as? String)!
                    var firstName = (dictionary["firstName"] as? String)!
                    var uidElse = (dictionary["uid"] as? String)!
                    
                    let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: self.view.frame.size.height + 40))
                    
                    //CGRectMake(self.collectionView.origin.x, 0, self.collectionView.width, self.collectionView.height - 100);
                
                    
                    navigationBar.barTintColor = UIColor.white
                    navigationBar.tintColor = UIColor.MUnchMatesBlue
                    //navigationBar.size.height = 60
                    //navigationBar.alignmentRect(forFrame: )

                    navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.MUnchMatesBlue]
                    
                
                    // Create a navigation item with a title
                    let navigationItem = UINavigationItem()
                    navigationItem.title = "\(fullName)"
                

                
                    // Create left and right button for navigation item
                    let leftButton =  UIBarButtonItem(title: "Messages", style: .plain, target: self, action: #selector(self.btnMessagesAction))
                
                    let rightButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(self.btnProfileAction))
                
                    // Create two buttons for the navigation item
                    navigationItem.leftBarButtonItem = leftButton
                    navigationItem.rightBarButtonItem = rightButton
                
                    // Assign the navigation item to the navigation bar
                    navigationBar.items = [navigationItem]
                
                    // Make the navigation bar a subview of the current view controller
                    self.view.addSubview(navigationBar)
            
                }
            })
        
        
//*****ANDREW'S VIEW****COPY ON SEPERATE VC*******//for menu
//        blurView.layer.cornerRadius = 15
//        sideView.layer.shadowColor = UIColor.black.cgColor
//        sideView.layer.shadowOpacity = 0.5
//        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
//
//        sidebarViewConstraint.constant = -180
        
        // Do any additional setup after loading the view.
    



//    @objc func btn_clicked(_ sender: UIBarButtonItem) {
//        // Do something
//        performSegue(withIdentifier: "segueBackToHomeVC", sender: self)
//    }
        
    }
    
    //nav bar btn actions
     @objc func btnMessagesAction() {
        performSegue(withIdentifier: "Message2ConversationTable", sender: self)
    }
    
    func btnProfileAction() {
        performSegue(withIdentifier: "Message2Profile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Message2Profile" {
            let vc = segue.destination as! ProfileMessageViewController
            vc.fromMessageToProfile = toUser
            vc.fromUserMessageProfile = fromUserMessage
        }
    }//toUser
    
    @objc func showDisplayNameDialog()
    {
        let defaults = UserDefaults.standard

        let alert = UIAlertController(title: "Your Display Name", message: "Before you can chat, please choose a display name. Others will see this name when you send chat messages. You can change your display name again by tapping the navigation bar.", preferredStyle: .alert)

        alert.addTextField { textField in

            if let name = defaults.string(forKey: "jsq_name")
            {
                textField.text = name
            }
//            else
//            {
//                let names = ["Ford", "Arthur", "Zaphod", "Trillian", "Slartibartfast", "Humma Kavula", "Deep Thought"]
//                textField.text = names[Int(arc4random_uniform(UInt32(names.count)))]
//            }
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] _ in

            if let textField = alert?.textFields?[0], !textField.text!.isEmpty {

                self?.senderDisplayName = textField.text

                self?.title = "Chat: \(self!.senderDisplayName!)"

                defaults.set(textField.text, forKey: "jsq_name")
                defaults.synchronize()
            }
        }))

        present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return nil //messages[indexPath.item].senderId == senderId ? nil : NSAttributedString()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        var conversationID: String = toUser.uid
        var userDisplayName:String = fromUserMessage.userDisplayName
        var timeStampPos = NSDate().timeIntervalSince1970 //get timestamp
        var timeStampNeg = timeStampPos * -1 //make timestamp negative to order the users in decending order in ConversationViewController
        var readFalse = false
        var readTrue = true

        //change ref to point to correct conversation
        let senderRef = Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations/messageList/\(conversationID)/messages/").childByAutoId()
        let senderMessage = ["sender_id": senderId, "name": senderDisplayName, "text": text]//, "timeStamp":timeStampPos] as [String : Any]
        senderRef.setValue(senderMessage)
        
        let receiverRef = Constants.refs.databaseRoot.child("USERS/\(conversationID)/conversations/messageList/\(uid!)/messages/").childByAutoId()
        
        let receiverMessage = ["sender_id": senderId, "name": senderDisplayName, "text": text]//, "timeStamp":timeStampPos] as [String : Any]
        receiverRef.setValue(receiverMessage)
       
        let ref = Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations/senderList/\(conversationID)")
        let toUserIDValue = ["uid": conversationID, "userDisplayName": toUser.firstName + " " + toUser.lastName,"timeStamp":timeStampNeg,"read":readTrue] as [String : Any]
        ref.setValue(toUserIDValue)
        
        let ref2 = Constants.refs.databaseRoot.child("USERS/\(conversationID)/conversations/senderList/\(uid!)")
        let fromUserIDValue = ["uid": uid, "userDisplayName": userDisplayName,"timeStamp":timeStampNeg,"read":readFalse] as [String : Any]
        ref2.setValue(fromUserIDValue)
        
        finishSendingMessage()
        
        //count messages in convo and delete if over 20 - SENDING (current) USER
        Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations/messageList/\(conversationID)/messages/").observe(.value, with:
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
                    
                        Constants.refs.databaseRoot.child("USERS/\(self.uid!)/conversations/messageList/\(conversationID)/messages/\(nodeToDelete)").removeValue()
                    }
                }
        })
        
        //count messages in convo and delete if over 20 - RECEIVING USER
        Constants.refs.databaseRoot.child("USERS/\(conversationID)/conversations/messageList/\(uid!)/messages/").observe(.value, with:
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
                        
                        Constants.refs.databaseRoot.child("USERS/\(conversationID)/conversations/messageList/\(self.uid!)/messages/\(nodeToDelete)").removeValue()
                    }
                }
        })
    }
    
    //awebber testing git push
//    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
//
//        //for when the user is swiping to the right
//        if (sender.state == .began || sender.state == .changed) {
//
//            //the translation is our variable for speed of movment
//            let translation = sender.translation(in: self.view).x
//
//            //if translation is positive, or being dragged on screen - once it hits 20 it will automatically pull the rest of the way out
//            if (translation > 0) {
//                if(sidebarViewConstraint.constant < 20){
//                    UIView.animate(withDuration: 0.2, animations: {
//                        self.sidebarViewConstraint.constant += translation / 10
//                        self.view.layoutIfNeeded()
//                    })
//                }
//            }else {
//                //if translation is negative, or being dragged off screen - it will automatically pull the rest of the way out until it is hidden at -180
//                if(sidebarViewConstraint.constant > -180){
//                    UIView.animate(withDuration: 0.2, animations: {
//                        self.sidebarViewConstraint.constant += translation / 10
//                        self.view.layoutIfNeeded()
//                    })
//                }
//            }
//
//        }else if sender.state == .ended {
//
//            //once the sidebar hits -20 it will automatically hide off screen
//            if(sidebarViewConstraint.constant < -20){
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.sidebarViewConstraint.constant = -180
//                    self.view.layoutIfNeeded()
//                })
//            }else {
//                //if it doesn't hit -20 it will come back out on screen
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.sidebarViewConstraint.constant = 0
//                    self.view.layoutIfNeeded()
//                })
//            }
//
//        }
//
//    }

}
