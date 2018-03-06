//
//  SearchUsersUid.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 12/14/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

struct SearchUsersUid {
    let searchUid: String
    let ref: DatabaseReference?
    
    init() {
        self.searchUid = " "
        self.ref = nil
    }
    
    init(searchUid: String) {
        self.searchUid = searchUid
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        searchUid = snapshotValue["uid"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "searchUid": searchUid as Any
        ]
    }
}

