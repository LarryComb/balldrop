//
//  Background.swift
//  BallDrop
//
//  Created by LARRY COMBS on 12/6/17.
//  Copyright © 2017 LARRY COMBS. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ground = SKSpriteNode()
    
        
    
    override func didMove(to view: UIView) {
        self.anchorPoint = CGPoint (x: 0.5, y: 0.5)
        createGround()
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveGround()
    }
    func createGround() {
        for i in 0...3{
            let ground = SKSpriteNode(imageNamed: "ground")
            ground.name = "Ground"
            ground.size = CGSize(width: (self.scene?.size.width)!, height: 250)
            ground.anchorPoint = CGPoint (x: 0.5, y: 0.5)
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))
            
            self.addChild(ground)
        }
    }
    
    func moveGround() {
        self.enumerateChildNodes(withName: "Ground", using: ({
            (node, error) in
            node.position.x -= 3
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 3
            }
            
        }))
    }
}

