//
//  GrapherViewController.swift
//  Calculator-Project3
//
//  Created by Adam Wyeth on 7/8/15.
//  Copyright (c) 2015 ITunesUStan. All rights reserved.
//

import UIKit

class GrapherViewController: UIViewController, GrapherViewDataSource {

    
    @IBOutlet weak var grapherView: GrapherView! {
        didSet {
            grapherView.dataSource = self
            
        }
    }
    
  //  viewWillLoad()
    //NO GEOMETRY RELATED STUFF HERE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        // Do any additional setup after loading the view.
        grapherView?.setNeedsDisplay()
        
    }

    //This can be used to optimize performance by waiting until this method is called
    //ex. Going to the network to get some data or something
    //can do geometry stuff starting here
    /*override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
     
        
    }
    
    
    //viewDidAppear()

    viewWillDisappear()
    viewDidDisappear()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    /*
    for geometry
    viewWillLayoutSubview()
    viewDidLayoutSubviews()
    
    //For specifying what to do with autorotation
    viewWillTransitionToSize()
    */
    
    var graphFun : (Double -> Double)?
    
    
    var graphViewDescription:String = ""
    
    
    func descriptionForDescriptionLabel(sender: GrapherView) -> String {
        return graphViewDescription
    }
    
    func functionForGraph(sender: GrapherView) -> (Double -> Double)? {
        return graphFun
    }
    
  }
