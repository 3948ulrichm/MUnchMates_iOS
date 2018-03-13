//
//  FilterVCToSearchVCStruct.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 2/23/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase


//populate this struct with the buttons from FilterViewController. When "Search" is hit, send value to SearchListViewController. Use values to filter search. NOTE: try clubsOrgsSearch last as it might take extra steps because it will be an extra node down the Db.
struct FilterVCToSearchVCStruct {
    let entitySearch: String?
    let attributeSearch: String?
    //let ref: DatabaseReference?
    
    init() {
        self.entitySearch = ""
        self.attributeSearch = ""
       // self.ref = nil
    }
    
    init(entitySearch:String, attributeSearch:String) {
        self.entitySearch = entitySearch
        self.attributeSearch = attributeSearch
        //self.ref = nil
    }
    
//    init(snapshot: DataSnapshot) {
//        let snapshotValue = snapshot.value as! [String: AnyObject]
//        entitySearch = (snapshotValue[""] as? String)!
//        attributeSearch = (snapshotValue[""] as? String)!
//        ref = snapshot.ref
//    }
    
    func toAnyObject() -> Any {
        return [
            "entitySearch": entitySearch as Any,
            "attributeSearch": attributeSearch as Any
        ]
    }
}

