//
//  FromWelcomePageStruct.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/13/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation

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

