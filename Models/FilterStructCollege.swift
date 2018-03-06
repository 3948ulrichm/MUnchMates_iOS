//
//  FilterStructCollege.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 2/17/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

struct FilterStructCollege {
    let collegeName: String?
    let ref: DatabaseReference?
    
    init() {
        self.collegeName = ""
        self.ref = nil
    }
    
    init(collegeName: String) {
        self.collegeName = collegeName
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        collegeName = (snapshotValue["collegeName"] as? String)!
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "collegeName": collegeName as Any
        ]
    }
}
