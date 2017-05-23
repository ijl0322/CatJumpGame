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
        parent!.physicsBody?.categoryBitMask = PhysicsCategory.LeftCat
        parent!.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Obstacle | PhysicsCategory.Floor | PhysicsCategory.Floor
        parent!.physicsBody?.contactTestBitMask = PhysicsCategory.Bread | PhysicsCategory.LeftWood | PhysicsCategory.RightWood
        
        let rotationConstraint = SKConstraint.zRotation(
            SKRange(lowerLimit: -30.toRadians(), upperLimit: 30.toRadians()))
        parent!.constraints = [rotationConstraint]
    }
    
    func throwCat() {
        parent!.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5000))
    }
    
    func dropSlightly() {
        parent!.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -300))
    }
    
//    func sitOnSeesaw(seesaw: SeesawNode) {
//        let position = seesaw.position
//        var localPoint = parent!.convert(position, from: scene!)
//        localPoint.y += seesaw.frame.height
//        localPoint.x -= seesaw.frame.width/4
//        run(SKAction.move(to: localPoint, duration: 0.1))
//    }
    
    func gravityLess() {
        print("Start Gravityless")
        parent!.physicsBody?.affectedByGravity = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            print("End Gravityless")
            self.parent!.physicsBody?.affectedByGravity = true
        })
    }
}
