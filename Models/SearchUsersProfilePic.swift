//
//  SearchUsersProfilePic.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 12/14/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

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

