//
//  UsersInConversations.swift
//  MUnchMates
//
//  Created by Andrew Webber on 3/8/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

// structs are used to get data to and from a database and pass data between view controllers. the structs in the "Models" folders are used throughout the app.
struct UserInConversations {
    let read: Bool
    let timeStamp: Double
    let uid: String
    let userDisplayName: String
    let ref: DatabaseReference?
    
    init() {
        self.read = true
        self.timeStamp = 0.00
        self.uid = " "
        self.userDisplayName = " "
        self.ref = nil
    }
    
    init(read:Bool, timeStamp:Double, uid:String, userDisplayName:String){
        self.read = read
        self.timeStamp = timeStamp
        self.uid = uid
        self.userDisplayName = userDisplayName
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        read = snapshotValue["read"] as! Bool
        timeStamp = snapshotValue["timeStamp"] as! Double
        uid = snapshotValue["uid"] as! String
        userDisplayName = snapshotValue["userDisplayName"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "read": read as Any,
            "timeStamp":timeStamp as Any,
            "uid": uid as Any,
            "userDisplayName": userDisplayName as Any
        ]
    }
}
