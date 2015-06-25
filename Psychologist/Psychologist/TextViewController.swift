//
//  TextViewController.swift
//  Psychologist
//
//  Created by Adam Wyeth on 6/24/15.
//  Copyright (c) 2015 ITunesUStan. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    
    @IBOutlet weak var TextView: UITextView! {
        didSet {
            TextView.text = text
        }
    }
    
    var text: String = "" {
        didSet {
            TextView?.text = text
        }
    }
    
    override var preferredContentSize: CGSize {
        get {
            if TextView != nil && presentingViewController != nil {
                return TextView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else {
                return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue}
    }

}
