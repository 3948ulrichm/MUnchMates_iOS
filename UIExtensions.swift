//
//  UIColorExtension.swift
//  MUnchMates
//
//  Created by Michael Ulrich on 3/10/18.
//  Copyright © 2018 Michael Ulrich. All rights reserved.
//

// This file has extensions that can be called throughout the app.

import UIKit
import CoreFoundation

// This extension is for font color. It is the exact gold and blue colors that are in our logo.
extension UIColor {
    
    // Setup custom colors we can use throughout the app using hex values
    static let MUnchMatesBlue = UIColor(hex: 0x001CB8)
    static let MUnchMatesGold = UIColor(hex: 0xFCB723)
    
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}

// This extension dismisses the keyboard when any area of the screen, other than the keyboard, is touched.
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
