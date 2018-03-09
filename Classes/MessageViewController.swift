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

class MessageViewController: JSQMessagesViewController {

    @IBOutlet weak var sidebarViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sideView: UIView!
    
    var toUser = SearchUsers()
    var toUserCon = UserInConversations()
    
    var messages = [JSQMessage]()
    var senderUser = SearchUsers()
    let uid = Auth.auth().currentUser?.uid
    let user = Auth.auth().currentUser
    let userDisplayName = Auth.auth().currentUser?.displayName
    var conversationID: String?
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for messaging
        let defaults = UserDefaults.standard
        
        //var fullString: String?
        //let uid = Auth.auth().currentUser?.uid
        
//        Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations").observe(.value, with: { snapshot in
//            // get the entire snapshot dictionary
//            if let dictionary = snapshot.value as? [String: Any]
//            {
//                let fName = (dictionary["firstName"] as? String)! // + " " + (dictionary["lastName"] as? String)!
//                let lName = (dictionary["lastName"] as? String)!
//                let mealPlan = (dictionary["mealPlan"] as? Bool)!
//                let mateType = (dictionary["mateType"] as? String)!
//                let college = (dictionary["college"] as? String)!
//                let userID = (dictionary["uid"] as? String)!
//                let sendingUser = SearchUsers(firstName: fName, lastName: lName, mealPlan: mealPlan, mateType: mateType, college: college, uid: userID)
//                self.senderUser = sendingUser
//            }
//        })
        //var uctest: [String] = []
      //  print("**********************************************\(toUser.uid) **")
//        Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations/").observe(.value, with:
//        { snapshot in
//            var UserConversationArray: [UserConversations] = []
//
//            for UserConversationInfo in snapshot.children {
//                let fireAccount = UserConversations(snapshot: UserConversationInfo as! DataSnapshot)
//                UserConversationArray.append(fireAccount)
//                uctest.append(fireAccount.uid)
//                //if(toUser.uid == ){
//
//            }
        
//            for index in 0..<UserConversationArray.count{
//                if(self.toUser.uid == UserConversationArray[index].uid){
//                    print("**********************************************true")
//                }
//                print("**********************************************\(toUser.uid)")
//            }
            
                //self.debitArray = fireAccountArray
                //self.tableView.reloadData()
        //})
        
//        for index in 0..<uctest.count{
//            if(toUser.uid == uctest[index]){
//                print("**********************************************true")
//            }
//            print("**********************************************\(toUser.uid)")
//        }
        
        
        if  let id = uid//defaults.string(forKey: "jsq_id"),
            //let name = senderUser.firstName//defaults.string(forKey: "jsq_name")
        {
            senderId = id
            senderDisplayName = userDisplayName//user?.displayName//user?.email
        }
        else
        {
            senderId = uid//String(arc4random_uniform(999999))
            senderDisplayName = userDisplayName//user?.displayName

            defaults.set(senderId, forKey: "jsq_id")
            //defaults.set(senderDisplayName, forKey: "jsq_id")
            defaults.synchronize()

            showDisplayNameDialog()
        }
        
        title = "Chat: \(senderDisplayName!)"

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDisplayNameDialog))
        tapGesture.numberOfTapsRequired = 1

        navigationController?.navigationBar.addGestureRecognizer(tapGesture)

        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        
//        super.viewDidLoad()
//        ref.reference(withPath: "debits/\(currentUser.uid)").queryOrdered(byChild: "dateAdded").observe(.value, with:
//            //ref.reference(withPath: "test/").queryOrdered(byChild: "dateAdded").observe(.value, with:
//            { snapshot in
//                var fireAccountArray: [Debits] = []
//
//                for fireAccount in snapshot.children {
//                    let fireAccount = Debits(snapshot: fireAccount as! DataSnapshot)
//                    fireAccountArray.append(fireAccount)
//
//                }
//
//                self.debitArray = fireAccountArray
//                self.tableView.reloadData()
//        })
        
        
        
       // print("**********************************************\(toUser.uid) **")
        
        
//        if(toUser.uid == "1dcXCrbu1sMfeV8X8WrBJErpmQS2"){
//            conversationID = 3
//        }else{
//            conversationID = 1
//        }
        
        //conversationID = toUser.uid
        
        conversationID = toUserCon.uid
        
        
        //1dcXCrbu1sMfeV8X8WrBJErpmQS2
        
        //conversationID = 1
        
        //observe new messages (populate)
        //change ref to point to conversation if found, or make new one
        //let query = Constants.refs.databaseChats.queryLimited(toLast: 10)
        
        //let query = Constants.refs.databaseRoot.child("CONVERSATIONS/\(conversationID!)/messages/")
        
        let query = Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations/messageList/\(conversationID!)/messages/")

        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
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
        
        
        
        //for menu
        blurView.layer.cornerRadius = 15
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.5
        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        sidebarViewConstraint.constant = -180
        
        // Do any additional setup after loading the view.
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
        //change ref to point to correct conversation
        let senderRef = Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations/messageList/\(conversationID!)/messages/").childByAutoId()
        let senderMessage = ["sender_id": senderId, "name": senderDisplayName, "text": text]
        senderRef.setValue(senderMessage)
        
        let receiverRef = Constants.refs.databaseRoot.child("USERS/\(conversationID!)/conversations/messageList/\(uid!)/messages/").childByAutoId()
        let receiverMessage = ["sender_id": senderId, "name": senderDisplayName, "text": text]
        receiverRef.setValue(receiverMessage)
       
        let ref = Constants.refs.databaseRoot.child("USERS/\(uid!)/conversations/senderList/\(conversationID!)")
        let toUserIDValue = ["uid": conversationID, "userDisplayName": toUser.firstName + " " + toUser.lastName]
        ref.setValue(toUserIDValue)
        
        let ref2 = Constants.refs.databaseRoot.child("USERS/\(conversationID!)/conversations/senderList/\(uid!)")
        let fromUserIDValue = ["uid": uid, "userDisplayName": userDisplayName]
        ref2.setValue(fromUserIDValue)
        
        
        
        finishSendingMessage()
    }
    
    //awebber testing git push
    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
    
        //for when the user is swiping to the right
        if (sender.state == .began || sender.state == .changed) {
            
            //the translation is our variable for speed of movment
            let translation = sender.translation(in: self.view).x
    
            //if translation is positive, or being dragged on screen - once it hits 20 it will automatically pull the rest of the way out
            if (translation > 0) {
                if(sidebarViewConstraint.constant < 20){
                    UIView.animate(withDuration: 0.2, animations: {
                        self.sidebarViewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }else {
                //if translation is negative, or being dragged off screen - it will automatically pull the rest of the way out until it is hidden at -180
                if(sidebarViewConstraint.constant > -180){
                    UIView.animate(withDuration: 0.2, animations: {
                        self.sidebarViewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
            
        }else if sender.state == .ended {
            
            //once the sidebar hits -20 it will automatically hide off screen
            if(sidebarViewConstraint.constant < -20){
                UIView.animate(withDuration: 0.2, animations: {
                    self.sidebarViewConstraint.constant = -180
                    self.view.layoutIfNeeded()
                })
            }else {
                //if it doesn't hit -20 it will come back out on screen
                UIView.animate(withDuration: 0.2, animations: {
                    self.sidebarViewConstraint.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
            
        }
        
    
    }

}
