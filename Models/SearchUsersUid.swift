//
//  SearchUsersUid.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 12/14/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

// structs are used to get data to and from a database and pass data between view controllers. the structs in the "Models" folders are used throughout the app.
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

