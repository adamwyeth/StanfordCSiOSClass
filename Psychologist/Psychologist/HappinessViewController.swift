//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Adam Wyeth on 6/23/15.
//  Copyright (c) 2015 ITunesUStan. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {

    //Connects this controller to the View and sets the datasource
    //of the view to this controller
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            //colon in arguments means it takes the gesture as an argument
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
            }
    }
    
    private struct Constants {
        static let HappinessGestureScale: CGFloat = 4
    }
    
    
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default: break
        }
    }
    
    var happiness: Int = 100 { //0 = very sad, 100 = ecstatic
        didSet {
            happiness = min(max(happiness, 0), 100)
            println("happiness = \(happiness)")
            updateUI()
        }
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50) / 50
    }
    
    private func updateUI() {
        //force redraw on update
        //Any place that could be accessed with prepare use optional chaining
        faceView?.setNeedsDisplay()
        title = "\(happiness)"
    }

}
