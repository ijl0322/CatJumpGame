//
//  SeesawNode.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 17/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import SpriteKit
class SeesawNode: SKSpriteNode, EventListenerNode {
    private var leftContactPointNode = SKSpriteNode()
    private var rightContactPointNode = SKSpriteNode()
    var cat1Joint: SKPhysicsJointFixed?
    var cat1Fixed: Bool {
        return cat1Joint != nil
    }
    
    func didMoveToScene() {
        print("seesaw added to scene")
        
        guard let scene = scene else {
            return
        }
        
        // Set up physics body for the seesaw
        
        let seesawBodyTexture = SKTexture(imageNamed: "seesaw_physics")
        physicsBody = SKPhysicsBody(texture: seesawBodyTexture,
                                            size: seesawBodyTexture.size())
        physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        physicsBody?.collisionBitMask = PhysicsCategory.Cat1 | PhysicsCategory.Obstacle | PhysicsCategory.Floor
        physicsBody?.contactTestBitMask = 0
        
        
        // Add contact points for cat1 and cat2
        
        leftContactPointNode.size = CGSize(width: 30, height: 10)
        leftContactPointNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leftContactPointNode.position = CGPoint(x: -self.frame.size.width/4, y: self.frame.size.height/2)
        leftContactPointNode.physicsBody = SKPhysicsBody(rectangleOf: leftContactPointNode.frame.size)
        
        leftContactPointNode.physicsBody?.categoryBitMask = PhysicsCategory.LeftWood
        leftContactPointNode.physicsBody?.collisionBitMask = 0
        self.addChild(leftContactPointNode)
        
        rightContactPointNode.size = CGSize(width: 30, height: 10)
        rightContactPointNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rightContactPointNode.position = CGPoint(x: self.frame.size.width/4, y: self.frame.size.height/2)
        rightContactPointNode.physicsBody = SKPhysicsBody(rectangleOf: rightContactPointNode.frame.size)
        
        rightContactPointNode.physicsBody?.categoryBitMask = PhysicsCategory.RightWood
        rightContactPointNode.physicsBody?.collisionBitMask = 0
        self.addChild(rightContactPointNode)
        
        let leftEdgeJoint = SKPhysicsJointFixed.joint(withBodyA: physicsBody!, bodyB: leftContactPointNode.physicsBody!, anchor: self.position)
        scene.physicsWorld.add(leftEdgeJoint)
        
        let rightEdgeJoint = SKPhysicsJointFixed.joint(withBodyA: physicsBody!, bodyB: rightContactPointNode.physicsBody!, anchor: self.position)
        scene.physicsWorld.add(rightEdgeJoint)
        
        let moveConstaint = SKConstraint.positionY(SKRange(value: self.frame.size.height/2 + 100,
                                                    variance: 0))
        self.constraints = [moveConstaint]
    }
    
    func fixCat(catNode: CatNode) {
        guard let scene = scene else {
            return
        }
        
        if !cat1Fixed{
            catNode.parent?.zRotation = 0
            self.zRotation = 0
            cat1Joint = SKPhysicsJointFixed.joint(withBodyA: physicsBody!, bodyB: (catNode.parent?.physicsBody)!, anchor: self.position)
            scene.physicsWorld.add(cat1Joint!)
        }
    }
    
    func releaseCat() {
        if cat1Fixed {
            scene!.physicsWorld.remove(cat1Joint!)
            cat1Joint = nil
        }
    }


}
