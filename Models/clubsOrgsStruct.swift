//
//  clubsOrgsStruct.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 1/25/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

struct clubsOrgsStruct {
    let name1: String
    let ref: DatabaseReference?
    
    init() {
        self.name1 = " "
        self.ref = nil
    }
    
    init(name1: String) {
        self.name1 = name1
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name1 = snapshotValue["name1"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name1": name1 as Any
        ]
    }
}
