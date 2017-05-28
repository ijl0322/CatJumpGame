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
    
    let xPosition = [-350, -175, 0, 175, 350]
    let yPosition = [252, 70, -112]
    
    override func didMove(to view: SKView) {
        
        for i in 0...14 {
            var levelStatus = LevelCompleteType.locked
            if i < UserData.shared.unlockedLevels {
                levelStatus = UserData.shared.levelStatus[i]
            }
            let levelButton = LevelButtonNode(level: i+1, levelCompleteType: levelStatus)
            levelButton.position = CGPoint(x: xPosition[(i%5)], y: yPosition[(i/5)])
            levelButton.zPosition = 10
            addChild(levelButton)
            if i < UserData.shared.unlockedLevels && UserData.shared.highScores[i] == 0 {
                levelButton.animateButton()
            }
        }
        
        let leftCat = CatSpriteNode(catType: .cat1, isLeftCat: true)
        leftCat.physicsBody?.isDynamic = false
        leftCat.position = CGPoint(x: -320, y: 630)
        leftCat.zPosition = 10
        addChild(leftCat)
        
        let rightCat = CatSpriteNode(catType: .cat2, isLeftCat: false)
        rightCat.physicsBody?.isDynamic = false
        rightCat.position = CGPoint(x: 333, y: -704)
        rightCat.zPosition = 10
        addChild(rightCat)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  let touch = touches.first else {
            return
        }
        
        if let touchedNode =
            atPoint(touch.location(in: self)) as? SKSpriteNode {
            if touchedNode.name == "level" {
                let levelButton = touchedNode as? LevelButtonNode
                if levelButton?.levelCompleteType != .locked {
                    transitionToScene(level: (levelButton?.level)!)
                }
            }
        }
        
    }
    
    func transitionToScene(level: Int) {
        print("Transitionaing to new scene")
        if let newScene = GameScene.loadLevel(num: level) as! GameScene? ?? SKScene(fileNamed: "GameScene") as? GameScene  {
            newScene.scaleMode = .aspectFill
            newScene.level = Level(num: level)
            _ = newScene.level.loadBread()
            view!.presentScene(newScene,
                               transition: SKTransition.flipVertical(withDuration: 0.5))
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}


