//
//  Constants.swift
//  MUnchMates
//
//  Created by Andrew Webber on 1/21/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import Foundation
import Firebase

// structs are used to get data to and from a database and pass data between view controllers. the structs in the "Models" folders are used throughout the app.
// THIS STRUCT IS UNIQUE BC IT IS USED AS A DATABASE REFERENCE AND CAN BE CALLED THROUGHOUT THE APP.
struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
    }
}
