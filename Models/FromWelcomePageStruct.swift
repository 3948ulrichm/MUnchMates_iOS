//
//  FromWelcomePageStruct.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/13/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation

// structs are used to get data to and from a database and pass data between view controllers. the structs in the "Models" folders are used throughout the app.
struct FromWelcomePageStruct {
    let fromWelcomePage: Bool?
    
    init() {
        self.fromWelcomePage = false
    }
    
    init(fromWelcomePage:Bool) {
        self.fromWelcomePage = fromWelcomePage
    }
    
    func toAnyObject() -> Any {
        return [
            "fromWelcomePage": fromWelcomePage as Any
        ]
    }
}

