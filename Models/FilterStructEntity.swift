//
//  FilterStructEntity.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/12/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

struct FilterStructEntity {
    let filterEntityName: String?
    let ref: DatabaseReference?
    
    init() {
        self.filterEntityName = ""
        self.ref = nil
    }
    
    init(filterEntityName: String) {
        self.filterEntityName = filterEntityName
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        filterEntityName = (snapshotValue["filterEntityName"] as? String)!
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "filterEntityName": filterEntityName as Any
        ]
    }
}
