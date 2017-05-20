//
//  CatNode.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 18/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import SpriteKit
class CatNode: SKSpriteNode, EventListenerNode {
    var isPinned = false
    
    func didMoveToScene() {
        print("cat added to scene")
        let catBodyTexture = SKTexture(imageNamed: "cat1_physics")
        parent!.physicsBody = SKPhysicsBody(texture: catBodyTexture,
                                            size: catBodyTexture.size())
        parent!.physicsBody?.categoryBitMask = PhysicsCategory.Cat1
        parent!.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.LeftWood | PhysicsCategory.RightWood | PhysicsCategory.Obstacle
        parent!.physicsBody?.contactTestBitMask = PhysicsCategory.Bread | PhysicsCategory.LeftWood | PhysicsCategory.RightWood
        parent!.physicsBody?.friction = 1.0
        
        let rotationConstraint = SKConstraint.zRotation(
            SKRange(lowerLimit: -30.toRadians(), upperLimit: 30.toRadians()))
        parent!.constraints = [rotationConstraint]
        
    }
    
    func throwCat() {
        parent!.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 4000))
    }
    
    func gravityLess() {
        print("Start Gravityless")
        parent!.physicsBody?.affectedByGravity = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            print("End Gravityless")
            self.parent!.physicsBody?.affectedByGravity = true
        })
    }
}
