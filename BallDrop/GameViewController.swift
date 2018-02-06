//
//  GameViewController.swift
//  BallDrop
//
//  Created by LARRY COMBS on 10/22/17.
//  Copyright © 2017 LARRY COMBS. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    
  
    
    @IBOutlet var Cloud_Background: UIImageView!
    @IBOutlet weak var drawView: DrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
       
    }
    
    
    
    /*
     var dropBallTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector (DrawView.dropBall), userInfo: nil, repeats: true)
     */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.drawView.sendSubview(toBack: Cloud_Background)
        self.drawView.backgroundColor = UIColor(patternImage: UIImage(named: "Cloud_background.png")!)
      
        
        drawView.dropBall()
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

