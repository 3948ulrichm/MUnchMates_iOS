//
//  FilterStructMealPlan.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 2/18/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

// structs are used to get data to and from a database and pass data between view controllers. the structs in the "Models" folders are used throughout the app.
struct FilterStructMealPlan {
    let mealPlanName: String?
    let ref: DatabaseReference?
    
    init() {
        self.mealPlanName = ""
        self.ref = nil
    }
    
    init(mealPlanName: String) {
        self.mealPlanName = mealPlanName
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        mealPlanName = (snapshotValue["mealPlanName"] as? String)!
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "mealPlanName": mealPlanName as Any
        ]
    }
}
