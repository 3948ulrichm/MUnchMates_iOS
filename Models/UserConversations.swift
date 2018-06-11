//
//  UserConversations.swift
//  MUnchMates
//
//  Created by Andrew Webber on 3/5/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

// structs are used to get data to and from a database and pass data between view controllers. the structs in the "Models" folders are used throughout the app.
struct UserConversations {
    let uid: String
    let cid: String
    let ref: DatabaseReference?
    
    init() {
        self.uid = " "
        self.cid = " "
        self.ref = nil
    }
    
    init(uid:String, cid:String){
        self.uid = uid
        self.cid = cid
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        uid = snapshotValue["uid"] as! String
        cid = snapshotValue["cid"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "uid": uid as Any,
            "cid": cid as Any
        ]
    }
}
