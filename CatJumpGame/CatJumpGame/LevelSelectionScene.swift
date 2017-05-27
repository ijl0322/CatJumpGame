//
//  LevelSelectionScene.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 26/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import SpriteKit
import GameplayKit


class LevelSelectionScene: SKScene, SKPhysicsContactDelegate{
    
    override func didMove(to view: SKView) {
        let levelButton = LevelButtonNode(level: 1, levelCompleteType: .oneStar)
        levelButton.position = CGPoint(x: 0, y: -800)
        levelButton.zPosition = 100
        addChild(levelButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}


