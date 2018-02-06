//
//  GameScene.swift
//  BallDrop
//
//  Created by LARRY COMBS on 10/22/17.
//  Copyright © 2017 LARRY COMBS. All rights reserved.
//




import SpriteKit
import GameplayKit
import UIKit

import Foundation
import CoreGraphics




class DrawView:  UIView, UIGestureRecognizerDelegate, SKPhysicsContactDelegate {
    
    
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var ballTouch: UIDynamicItem!
    var boundries: UICollisionBehavior!
    //let cameraNode: SKCameraNode
    
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    var moveRecognizer: UIPanGestureRecognizer!
    
   

    //MARK: - Setup 
    
    func dropBall() {
        //Create a ball
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 20,y: 20), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.blue.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.red.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        let circleView = UIView(frame: CGRect(x: frame.width / 2, y: 0, width: 50, height: 50))
        addSubview(circleView)
        
        circleView.layer.addSublayer(shapeLayer)
        
        
        animator = UIDynamicAnimator(referenceView: self)
        gravity = UIGravityBehavior(items: [circleView])
        //Gives direction to bottom of screen
        let direction = CGVector(dx: 0.0, dy: 0.09)
        gravity.gravityDirection = direction
        //gravity?.angle = 0.70
        
        
        
        
        //Temporary Barrier to Test Collision
        let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 210, height: 20))
        barrier.backgroundColor = UIColor.red
        addSubview(barrier)
        
        
        
        
        
        
        //Add Collision Detection
        boundries = UICollisionBehavior(items: [circleView])
        boundries.translatesReferenceBoundsIntoBoundary = true
        
        //Add Collision between Barrier and CircleView
        boundries = UICollisionBehavior(items: [circleView])
        boundries.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: barrier.frame))
        
        boundries.collisionMode = .everything
        
        
        
        //Add Collision Detection with Cicle and Lines
        //let touchEachOther = UICollisionBehavior(items: [circleView, indexOfLine(at: CGPoint)])
        //boundries.addItem(indexOfLine(at: finishedLines))
        
        //UIBezierPath(
        
        
        
        animator?.addBehavior(boundries)
        animator?.addBehavior(gravity)
        
    }
    
    
    
    
   
    
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func stroke(_ line: Line) {
        
        
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    
    
    override func draw(_ rect: CGRect) {
        finishedLineColor.setStroke()
        for line in finishedLines {
            stroke(line)
            
        }
        
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            stroke(line)
            
        }
        
        if let index = selectedLineIndex{
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            stroke(selectedLine)
        }
        super.draw(rect)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Log statement to see the order of events
        print (#function)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location)
            
        
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()
       
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with: UIEvent?) {
        //Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
            
        }
        setNeedsDisplay()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with: UIEvent?) {
        //Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
                boundries.addBoundary(withIdentifier: "line" as NSCopying, from: line.begin, to: line.end);
            }
            
            
            
        }
        
        
        setNeedsDisplay()
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Log statement to see the order of events
        print(#function)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
        
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self,
                                                         action: #selector (DrawView.doubleTap(_:)))
        
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer (target: self, action: #selector (DrawView.moveLine(_:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
        
        let tapRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        
        
        
        dropBall();
        
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan")
        
        //If line is selected...
        if let index = selectedLineIndex{
            //When the pan recognizer change its position...
            if gestureRecognizer.state == .changed {
                //How far has the pan moved?
                let translation = gestureRecognizer.translation(in: self)
                
                //Add the translation to the current beginning and end points of the line
                //Make sure there are no copy and paste typos
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                
                //Redraw the screen
                setNeedsDisplay()
            }
        }  else {
            // If no line is selected, do not do anything
            return
            
        }
        
    }
    
    @objc func longPress(_ gestureRecogizer: UIGestureRecognizer) {
        print("Recognized a long press")
        
        if gestureRecogizer.state == .began {
            let point = gestureRecogizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll()
            }
        } else if gestureRecogizer.state == .ended {
            selectedLineIndex = nil
        }
        
        setNeedsDisplay()
    }
    
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer)  {
        print("Recognized a double tap")
        
        selectedLineIndex = nil
        currentLines.removeAll()
        finishedLines.removeAll()
        setNeedsDisplay()
    }
    
    
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer){
        print("Recognized a tap")
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        // Grab the menu controller
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            
            //Make DrawView the target of menu item action messages
            becomeFirstResponder()
            
            //Create a new "Delete" UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete",action: #selector(DrawView.deleteLine(_:)))
            menu.menuItems = [deleteItem]
            
            //Tell the menu where it should come from and show it
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        }else {
            
            //Hide the menu if no line is selected
            menu.setMenuVisible(false, animated: true)
            
            
        }
        
        setNeedsDisplay()
        
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func deleteLine(_ sender: UIMenuController) {
        //Remove the selected line from the list of finishedLines
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            
            //Redraw everything
            setNeedsDisplay()
            
        }
    }
    
    func indexOfLine(at point: CGPoint) -> Int? {
        //Find a line close to point
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            //Check a few points on the line
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                //If the tapped point is within 20 points, lets return this line
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                    
                }
            }
        }
        
       
        
        
        
        //If nothing is close enough to the tapped point, then we did not select a line
        return nil
 }
}
