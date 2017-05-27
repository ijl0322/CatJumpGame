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
            let levelButton = LevelButtonNode(level: i+1, levelCompleteType: .locked)
            levelButton.position = CGPoint(x: xPosition[(i%5)], y: yPosition[(i/5)])
            levelButton.zPosition = 10
            addChild(levelButton)
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
                if (levelButton?.level)! < 4 {
                    transitionToScene(level: (levelButton?.level)!)
                }
            }
        }
        
    }
    
    func transitionToScene(level: Int) {
        print("Transitionaing to new scene")
        guard let newScene = SKScene(fileNamed: "GameScene")
            as? GameScene else {
                fatalError("Level: \(level) not found")
        }
        newScene.scaleMode = .aspectFill
        newScene.level = Level(num: level)
        view!.presentScene(newScene,
                           transition: SKTransition.flipVertical(withDuration: 0.5))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}


