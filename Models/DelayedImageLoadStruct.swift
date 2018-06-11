//
//  DelayedImageLoadStruct.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/15/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation

// structs are used to get data to and from a database and pass data between view controllers. the structs in the "Models" folders are used throughout the app.
struct DelayedImageLoadStruct {
    let savedImage: Bool?
    
    init() {
        self.savedImage = false
    }
    
    init(savedImage:Bool) {
        self.savedImage = savedImage
    }
    
    func toAnyObject() -> Any {
        return [
            "savedImage": savedImage as Any
        ]
    }
}

