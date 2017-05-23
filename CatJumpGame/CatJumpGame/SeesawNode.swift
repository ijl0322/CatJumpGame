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
    var leftCatJoint: SKPhysicsJointFixed?
    var rightCatJoint: SKPhysicsJointFixed?
    var leftCatFixed: Bool {
        return leftCatJoint != nil
    }
    var rightCatFixed: Bool {
        return rightCatJoint != nil
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
        physicsBody?.collisionBitMask = PhysicsCategory.LeftCat | PhysicsCategory.RightCat | PhysicsCategory.Obstacle | PhysicsCategory.Floor
        physicsBody?.contactTestBitMask = 0
        
        
        // Add contact points for left cat and right cat
        
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
        let rotationConstraint = SKConstraint.zRotation(
            SKRange(lowerLimit: -30.toRadians(), upperLimit: 30.toRadians()))

        self.constraints = [moveConstaint, rotationConstraint]
    }
    
    func fixCat(catNode: CatSpriteNode) {
        guard let scene = scene else {
            return
        }
        
        if catNode.seatSide == .left {
            if !leftCatFixed{
                catNode.zRotation = 0
                self.zRotation = 0
                leftCatJoint = SKPhysicsJointFixed.joint(withBodyA: physicsBody!, bodyB: (catNode.physicsBody)!, anchor: self.position)
                scene.physicsWorld.add(leftCatJoint!)
            }
        } else {
            if !rightCatFixed{
                catNode.zRotation = 0
                self.zRotation = 0
                rightCatJoint = SKPhysicsJointFixed.joint(withBodyA: physicsBody!, bodyB: (catNode.physicsBody)!, anchor: self.position)
                scene.physicsWorld.add(rightCatJoint!)
            }
        }
    }
    
    func releaseCat(catSide: SeatSide) {
        
        switch catSide {
        case .left:
            if leftCatFixed {
                scene!.physicsWorld.remove(leftCatJoint!)
                leftCatJoint = nil
            }
            return
        case .right:
            if rightCatFixed {
                scene!.physicsWorld.remove(rightCatJoint!)
                rightCatJoint = nil
            }
            return
        }
    }
}
