//
//  GrapherView.swift
//  Calculator-Project3
//
//  Created by Adam Wyeth on 8/30/15.
//  Copyright (c) 2015 ITunesUStan. All rights reserved.
//

import UIKit

protocol GrapherViewDataSource: class {
    
    
    //generic graphing function
    func descriptionForDescriptionLabel(sender: GrapherView) -> String
    func functionForGraph(sender:GrapherView) -> (Double -> Double)?
    
}

@IBDesignable
class GrapherView: UIView {

    let drawer = AxesDrawer()
    
    @IBInspectable var scale: CGFloat = 0.90 {didSet {setNeedsDisplay()}}
    
    weak var dataSource: GrapherViewDataSource?
    
    
    @IBOutlet weak var descriptionView: UILabel! 
    
    var grapherCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    
    @IBInspectable var xTransform: CGFloat = 0 {didSet {setNeedsDisplay()}}
    @IBInspectable var yTransform: CGFloat = 0 {didSet {setNeedsDisplay()}}
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let descrip = dataSource?.descriptionForDescriptionLabel(self)
        descriptionView.text = descrip
        
        drawer.contentScaleFactor = self.contentScaleFactor
        
        let pointsPerUnit = 20 * scale
        
        let transform = bounds.maxX / scale / 2
        let origin = CGPoint(x: grapherCenter.x + xTransform, y: grapherCenter.y + yTransform)
        drawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: pointsPerUnit)
        
        
        let minX = Double((bounds.minX - xTransform - grapherCenter.x) / pointsPerUnit)
        let maxX = Double((bounds.maxX - xTransform - grapherCenter.x) / pointsPerUnit)
        /*let maxX = Double(transform  - (xTransform / pointsPerUnit))
        let minY = Double(-transform + (yTransform / pointsPerUnit))
        let maxY = Double(transform + (yTransform) / pointsPerUnit)*/
        print("minX: \(minX)" + ", ")
        print("maxX: \(maxX)" + ", ")
        //print("minY: \(minY)" + ", ")
        //print("maxY: \(maxY)" + ", ")
        print("scale: \(Double(scale))" + ", ")
        print("points per unit: \(Double(pointsPerUnit))" + ", ")
        var xs = [Double]()
        let dx = (maxX - minX) / 1000
        for (var i: Double = 0; i <= 1000; i++)
        {
            xs.append(minX + (dx * i))
        }
        
        if let f = dataSource?.functionForGraph(self)
        {
        
            let ys = getYsForXs(xs, function: f)
            var lastPointValid = false
            let path = UIBezierPath()
            for i in 0...1000
            {
                if (lastPointValid == false)
                {
                    if (ys[i].isNormal || ys[i].isZero)
                    {
                        path.moveToPoint(CGPoint(x: xs[i] * Double(pointsPerUnit) + Double(xTransform + grapherCenter.x),
                            y: -ys[i] * Double(pointsPerUnit) + Double(yTransform + grapherCenter.y)))
                        lastPointValid = true
                    }
                }
                else {
                    if (ys[i].isNormal || ys[i].isZero)
                    {
                        path.addLineToPoint(CGPoint(x: xs[i] * Double(pointsPerUnit) + Double(xTransform + grapherCenter.x),
                            y: -ys[i] * Double(pointsPerUnit) + Double(yTransform + grapherCenter.y)))
                    }
                    else {
                        lastPointValid = false
                    }
                }
            }
        
            path.stroke()
        }
    }
    
    func getYsForXs(xs: [Double], function: (Double ->Double)) -> [Double]
    {
        var ys = [Double]()
        for item in xs
        {
            ys.append(function(item))
        }
        return ys
    }
    
    
    /*These should probably be moved out of the grapherView and an intermediate function should be called
    to adjust theinternal variables */
    
    var oldScale:CGFloat = 0
    
    @IBAction func zoom(gesture: UIPinchGestureRecognizer) {
        print("in zoom")
        
        
        
        switch gesture.state {
        case .Began:
            oldScale = scale
            fallthrough
        case .Changed: fallthrough
        case .Ended:
            scale = gesture.scale * oldScale
        default:
            print("Hi")
        }
        
    }
    
    var oldXTransform:CGFloat = 0
    var oldYTransform:CGFloat = 0
    
    @IBAction func pan(gesture: UIPanGestureRecognizer) {
        
        let trans = gesture.translationInView(self)
        
        print("in pan")
        switch gesture.state {
        case .Began:
            oldXTransform = xTransform
            oldYTransform = yTransform
            fallthrough
        case .Ended: fallthrough
        case .Changed:
            xTransform = oldXTransform + trans.x
            yTransform = oldYTransform + trans.y
        default:
            print("Hi")
        }
    }
    
    @IBAction func doubleTap(gesture: UITapGestureRecognizer)
    {
        if (gesture.state == UIGestureRecognizerState.Ended)
        {
            let loc = gesture.locationInView(self)
            
            xTransform = loc.x - grapherCenter.x
            yTransform = loc.y - grapherCenter.y
        }
    }

    
    
    

}
