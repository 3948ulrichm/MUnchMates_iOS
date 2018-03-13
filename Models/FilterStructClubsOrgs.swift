//
//  FilterStructClubsOrgs.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 2/18/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

struct FilterStructClubsOrgs {
    let clubsOrgsName: String?
    let clubsOrgsId: String?
    let ref: DatabaseReference?
    
    init() {
        self.clubsOrgsName = ""
        self.clubsOrgsId = ""
        self.ref = nil
    }
    
    init(clubsOrgsName: String, clubsOrgsId:String) {
        self.clubsOrgsName = clubsOrgsName
        self.clubsOrgsId = clubsOrgsId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        clubsOrgsName = (snapshotValue["clubsOrgsName"] as? String)!
        clubsOrgsId = (snapshotValue["clubsOrgsId"] as? String)!
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "clubsOrgsName": clubsOrgsName as Any,
            "clubsOrgsId": clubsOrgsId as Any
        ]
    }
}

