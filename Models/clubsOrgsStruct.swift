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
    let cname: String
    //let cid: String
    let ref: DatabaseReference?
    
    init() {
        self.cname = " "
        //self.cid = " "
        self.ref = nil
    }
    
    init(cname: String, cid: String) {
        self.cname = cname
        //self.cid = cid
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        cname = snapshotValue["cname"] as! String
        //cid = snapshotValue["cid"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "cname": cname as Any
            //,"cid": cid as Any
        ]
    }
}
