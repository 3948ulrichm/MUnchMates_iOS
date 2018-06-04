//
//  BarButtonFont.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/19/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

// This class is used for the font of bar buttons throughout the app. It uses the MUnchMatesBlue extension created in UIExtensions.swift. If you select a bar button in main.storyboard and look at the right side helper bar, you will see that the class is "BarButtonFont".

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
