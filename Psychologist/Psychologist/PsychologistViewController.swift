//
//  ViewController.swift
//  Psychologist
//
//  Created by Adam Wyeth on 6/24/15.
//  Copyright (c) 2015 ITunesUStan. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {

    
    //Why segue in code?
    //Maybe you want to do different things based upon the state of the model/view
    @IBAction func nothing(sender: UIButton) {
        performSegueWithIdentifier("nothing", sender: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //unwraps if there is a navigation viewController. 
        //Nice in prepares in case there is a navigationViewController wrapping the MVC we want to prepare
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        if let hvc = destination as? HappinessViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "sad": hvc.happiness = 0
                    case "happy": hvc.happiness = 100
                    case "nothing": hvc.happiness = 25
                    default: hvc.happiness = 50
                }
            }
        }
    }

}

