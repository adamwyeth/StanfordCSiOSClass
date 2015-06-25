//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by Adam Wyeth on 6/24/15.
//  Copyright (c) 2015 ITunesUStan. All rights reserved.
//

import UIKit


class DiagnosedHappinessViewController:
    HappinessViewController, UIPopoverPresentationControllerDelegate
{
    //This doesn't override the didset of happiness in 
    //HappinessViewController! That is still executed as well!
    override var happiness: Int {
        didSet {
            diagnosticHistory += [happiness]
        }
    }
    
    
    //setting this here doesn't work because each time we load
    //the popover, it is a NEW popover history. Diagnostic history
    //needs to be stored somewhere else!
    //instead of using an array, need to use userdefaults
    //for permanent storage
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var diagnosticHistory: [Int] {
        get { return defaults.objectForKey(History.DefaultsKey) as? [Int] ?? []}
        set { defaults.setObject(newValue, forKey: History.DefaultsKey)}
    }
    
    //Again, put constants in a struct
    private struct History {
        static let SegueIdentifier = "Show Diagnostic History"
        //since NSUserDefaults is shared throughout the app,
        //we need a convention for the key, and this seems like a
        //reasonable one. [Class].[title]
        static let DefaultsKey = "DiagnosedHappinessViewController.History"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController {
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    tvc.text = "\(diagnosticHistory)"
                }
            default: break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    
}