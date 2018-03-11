//
//  PledgeViewController.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 12/3/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit
import Firebase

class PledgeViewController: UIViewController {
    
    let dataRef = Database.database().reference()
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblP1: UILabel!
    @IBOutlet weak var lblP2: UILabel!
    @IBOutlet weak var lblP3: UILabel!
    @IBOutlet weak var lblP4: UILabel!
    @IBOutlet weak var lblP5: UILabel!
    @IBOutlet weak var lblP6: UILabel!
    @IBOutlet weak var lblP7: UILabel!
    
    
    override func viewDidLoad() {
    
        dataRef.child("OTHER/pledge/").observe(.value, with: { snapshot in
            if let dictionary = snapshot.value as? [String: Any]
            {
                var title = (dictionary["title"] as? String)!
                var p1 = (dictionary["p1"] as? String)!
                var p2 = (dictionary["p2"] as? String)!
                var p3 = (dictionary["p3"] as? String)!
                var p4 = (dictionary["p4"] as? String)!
                var p5 = (dictionary["p5"] as? String)!
                var p6 = (dictionary["p6"] as? String)!
                var p7 = (dictionary["p7"] as? String)!
        
                self.lblTitle.text = title
                self.lblP1.text = p1
                self.lblP2.text = p2
                self.lblP3.text = p3
                self.lblP4.text = p4
                self.lblP5.text = p5
                self.lblP6.text = p6
                self.lblP7.text = p7
                
//                self.lblTitle.sizeToFit()
//                self.lblP1.sizeToFit()
//                self.lblP2.sizeToFit()
//                self.lblP3.sizeToFit()
//                self.lblP4.sizeToFit()
//                self.lblP5.sizeToFit()
//                self.lblP6.sizeToFit()
//                self.lblP7.sizeToFit()

            }
        })
    }
}
