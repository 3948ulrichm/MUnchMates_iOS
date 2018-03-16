//
//  DelayedImageLoadStruct.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/15/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation

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

