//
//  messageStruct.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/12/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

struct messagesStruct {
    let name: String
    let sender_id: String
    var text: String
    let ref: DatabaseReference?
    
    init() {
        self.name = " "
        self.sender_id = " "
        self.text = " "
        self.ref = nil
    }
    
    init(name: String, sender_id: String, text: String) {
        self.name = name
        self.sender_id = sender_id
        self.text = text
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        sender_id = snapshotValue["sender_id"] as! String
        text = snapshotValue["text"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name as Any,
            "sender_id": sender_id as Any,
            "text": text as Any
        ]
    }
}

