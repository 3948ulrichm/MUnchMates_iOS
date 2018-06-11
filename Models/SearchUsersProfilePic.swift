//
//  SearchUsersProfilePic.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 12/14/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

// structs are used to get data to and from a database and pass data between view controllers. the structs in the "Models" folders are used throughout the app.
struct SearchUsersProfilePic {
    let imgProfilePic: UIImageView?
    let ref: DatabaseReference?
    
    init() {
        self.imgProfilePic = nil
        self.ref = nil
    }
    
    init(imgProfilePic: UIImageView) {
        self.imgProfilePic = imgProfilePic
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        imgProfilePic = (snapshotValue["imgProfilePic"] as? UIImageView)!
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "imgProfilePic": imgProfilePic as Any
        ]
    }
}

