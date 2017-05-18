//
//  CatNode.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 18/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import SpriteKit
class CatNode: SKSpriteNode, EventListenerNode {
    func didMoveToScene() {
        print("cat added to scene")
        let catBodyTexture = SKTexture(imageNamed: "cat1_physics")
        parent!.physicsBody = SKPhysicsBody(texture: catBodyTexture,
                                            size: catBodyTexture.size())
        parent!.physicsBody?.categoryBitMask = PhysicsCategory.Cat1
        parent!.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.LeftWood | PhysicsCategory.RightWood | PhysicsCategory.Obstacle
        
        let rotationConstraint = SKConstraint.zRotation(
            SKRange(lowerLimit: -30.toRadians(), upperLimit: 30.toRadians()))
        parent!.constraints = [rotationConstraint]
        
    }
}
