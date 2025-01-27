//
//  clubsOrgsStruct.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 2/24/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

// structs are used to get data to and from a database and pass data between view controllers. the structs in the "Models" folders are used throughout the app.
struct clubsOrgsStruct {
    let clubsOrgsName: String
    let clubsOrgsId: String
    let ref: DatabaseReference?
    
    init() {
        self.clubsOrgsName = " "
        self.clubsOrgsId = " "
        self.ref = nil
    }
    
    init(clubsOrgsName: String, clubsOrgsId: String) {
        self.clubsOrgsName = clubsOrgsName
        self.clubsOrgsId = clubsOrgsId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        clubsOrgsName = snapshotValue["clubsOrgsName"] as! String
        clubsOrgsId = snapshotValue["clubsOrgsId"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "clubsOrgsName": clubsOrgsName as Any
            ,"clubsOrgsId": clubsOrgsId as Any
        ]
    }
}

