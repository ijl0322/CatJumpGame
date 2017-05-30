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
    
    // Pause game accordingly when the user taps home
    // Then perform segue
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        
        if let view = self.view as! SKView? {
            if let gameScene = view.scene as? GameScene {
                print("from a game")
                if gameScene.gameState == .play {
                    gameScene.gameState = .pause
                    gameScene.applicationDidEnterBackground()
                }
            }
        }
        performSegue(withIdentifier: "returnHomeSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "LevelSelectionScene") as? LevelSelectionScene  {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }
}
