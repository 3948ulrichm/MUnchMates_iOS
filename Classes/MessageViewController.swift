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
        
        //mark message as read
        Database.database().reference().child("USERS/\(uid!)/conversations/senderList/\(conversationID)/read").setValue(true)

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

        var title = "\(userDisplayName)"

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDisplayNameDialog))
        tapGesture.numberOfTapsRequired = 1

        navigationController?.navigationBar.addGestureRecognizer(tapGesture)

        inputToolbar.contentView.leftBarButtonItem = nil
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
        
        
//*****ANDREW'S VIEW****COPY ON SEPERATE VC*******//for menu
//        blurView.layer.cornerRadius = 15
//        sideView.layer.shadowColor = UIColor.black.cgColor
//        sideView.layer.shadowOpacity = 0.5
//        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
//
//        sidebarViewConstraint.constant = -180
        
        // Do any additional setup after loading the view.
    
    
    func addNavBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:54)) // Offset by 20 pixels vertically to take the status bar into account

        navigationBar.barTintColor = UIColor.black
        navigationBar.tintColor = UIColor.black

        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.green]

        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "NavBarAppears!"

        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Back", style:   .plain, target: self, action: nil)//#selector(btn_clicked(_:)))

        let rightButton = UIBarButtonItem(title: "Right", style: .plain, target: self, action: nil)

        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton

        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]

        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }


//    @objc func btn_clicked(_ sender: UIBarButtonItem) {
//        // Do something
//        performSegue(withIdentifier: "segueBackToHomeVC", sender: self)
//    }
    }
    
    
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
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
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
