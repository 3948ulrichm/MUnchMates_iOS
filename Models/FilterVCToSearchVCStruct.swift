//
//  FilterVCToSearchVCStruct.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 2/23/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

// structs are used to get data to and from a database and pass data between view controllers. the structs in the "Models" folders are used throughout the app.
struct FilterVCToSearchVCStruct {
    let entitySearch: String?
    let attributeSearch: String?
    
    init() {
        self.entitySearch = ""
        self.attributeSearch = ""
    }
    
    init(entitySearch:String, attributeSearch:String) {
        self.entitySearch = entitySearch
        self.attributeSearch = attributeSearch
    }
    
    func toAnyObject() -> Any {
        return [
            "entitySearch": entitySearch as Any,
            "attributeSearch": attributeSearch as Any
        ]
    }
}

