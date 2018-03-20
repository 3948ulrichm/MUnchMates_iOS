//
//  BarButtonFont.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/19/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

import UIKit

class BarButtonFont: UIBarButtonItem {
    override func awakeFromNib() {
        style = .plain
        tintColor = .MUnchMatesBlue
        
        //Set font name and size
        guard let font = UIFont(name: "Arial", size: 15) else {
            return
        }
        
        setTitleTextAttributes([NSAttributedStringKey.font:font], for: .normal)
    }
}
