//
//  MenuViewController.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 26/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import UIKit
import SpriteKit


class MenuViewController: UIViewController {
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        
        if let view = self.view as! SKView? {
            if let gameScene = view.scene as? GameScene {
                print("from a game")
                gameScene.gameState = .pause
                gameScene.applicationDidEnterBackground()
            }
        }
        performSegue(withIdentifier: "returnHomeSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "LevelSelectionScene") as? LevelSelectionScene  {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }
}
