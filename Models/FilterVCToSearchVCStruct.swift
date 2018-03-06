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
    let mateTypeSearch: String?
    let collegeSearch: String?
    let mealPlanSearch: String?
    let clubsOrgsSearch: String?
    let ref: DatabaseReference?
    
    init() {
        self.mateTypeSearch = ""
        self.collegeSearch = ""
        self.mealPlanSearch = ""
        self.clubsOrgsSearch = ""
        self.ref = nil
    }
    
    init(mateTypeSearch:String, collegeSearch:String, mealPlanSearch:String, clubsOrgsSearch: String) {
        self.mateTypeSearch = mateTypeSearch
        self.collegeSearch = collegeSearch
        self.mealPlanSearch = mealPlanSearch
        self.clubsOrgsSearch = clubsOrgsSearch
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        mateTypeSearch = (snapshotValue["mateType"] as? String)!
        collegeSearch = (snapshotValue["college"] as? String)!
        mealPlanSearch = (snapshotValue["mealPlan"] as? String)!
        clubsOrgsSearch = (snapshotValue["clubsOrgs"] as? String)!
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "mateType": mateTypeSearch as Any,
            "college": collegeSearch as Any,
            "mealPlan": mealPlanSearch as Any,
            "clubsOrgs": clubsOrgsSearch as Any
        ]
    }
}

