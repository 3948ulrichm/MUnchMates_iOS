//
//  UsersInConversations.swift
//  MUnchMates
//
//  Created by Andrew Webber on 3/8/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

struct UserInConversations {
    let uid: String
    let userDisplayName: String
    let ref: DatabaseReference?
    
    init() {
        self.uid = " "
        self.userDisplayName = " "
        self.ref = nil
    }
    
    init(uid:String, userDisplayName:String){
        self.uid = uid
        self.userDisplayName = userDisplayName
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        uid = snapshotValue["uid"] as! String
        userDisplayName = snapshotValue["userDisplayName"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "uid": uid as Any,
            "userDisplayName": userDisplayName as Any
        ]
    }
}
