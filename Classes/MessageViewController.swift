//
//  MessageViewController.swift
//  MUnchMates
//
//  Created by Andrew Webber on 12/20/17.
//  Copyright © 2017 Michael Ulrich. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var sidebarViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sideView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.layer.cornerRadius = 15
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.5
        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        sidebarViewConstraint.constant = -180
        
        // Do any additional setup after loading the view.
    }
    
    //awebber testing git push
    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
    
        //for when the user is swiping to the right
        if (sender.state == .began || sender.state == .changed) {
            
            //the translation is our variable for speed of movment
            let translation = sender.translation(in: self.view).x
    
            //if translation is positive, or being dragged on screen - once it hits 20 it will automatically pull the rest of the way out
            if (translation > 0) {
                if(sidebarViewConstraint.constant < 20){
                    UIView.animate(withDuration: 0.2, animations: {
                        self.sidebarViewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }else {
                //if translation is negative, or being dragged off screen - it will automatically pull the rest of the way out until it is hidden at -180
                if(sidebarViewConstraint.constant > -180){
                    UIView.animate(withDuration: 0.2, animations: {
                        self.sidebarViewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
            
        }else if sender.state == .ended {
            
            //once the sidebar hits -20 it will automatically hide off screen
            if(sidebarViewConstraint.constant < -20){
                UIView.animate(withDuration: 0.2, animations: {
                    self.sidebarViewConstraint.constant = -180
                    self.view.layoutIfNeeded()
                })
            }else {
                //if it doesn't hit -20 it will come back out on screen
                UIView.animate(withDuration: 0.2, animations: {
                    self.sidebarViewConstraint.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
            
        }
        
    
    }

}
