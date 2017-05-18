//
//  SeesawBaseNode.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 17/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import SpriteKit
class SeesawBaseNode: SKSpriteNode, EventListenerNode,
InteractiveNode {
    
    private var leftWoodNode = SKSpriteNode(imageNamed: "seesaw")
    private var rightWoodNode = SKSpriteNode(imageNamed: "seesaw")
    
    func didMoveToScene() {
        guard let scene = scene else {
            return
        }
        
        leftWoodNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leftWoodNode.position = CGPoint(x: -leftWoodNode.size.width/2, y: leftWoodNode.size.height)
        leftWoodNode.physicsBody = SKPhysicsBody(rectangleOf: leftWoodNode.frame.size)
        leftWoodNode.physicsBody?.affectedByGravity = true
        leftWoodNode.physicsBody?.isDynamic = true
        leftWoodNode.physicsBody?.categoryBitMask = PhysicsCategory.LeftWood
        leftWoodNode.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Seesaw
        self.addChild(leftWoodNode)
        
        rightWoodNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rightWoodNode.position = CGPoint(x: rightWoodNode.size.width/2, y: rightWoodNode.size.height)
        rightWoodNode.physicsBody = SKPhysicsBody(rectangleOf: rightWoodNode.frame.size)
        rightWoodNode.physicsBody?.affectedByGravity = true
        rightWoodNode.physicsBody?.isDynamic = true
        rightWoodNode.physicsBody?.categoryBitMask = PhysicsCategory.RightWood
        rightWoodNode.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Seesaw
        self.addChild(rightWoodNode)
        
        let woodJoint = SKPhysicsJointFixed.joint(withBodyA: leftWoodNode.physicsBody!, bodyB: rightWoodNode.physicsBody!, anchor: CGPoint.zero)
        scene.physicsWorld.add(woodJoint)
        
        let baseJoint = SKPhysicsJointFixed.joint(withBodyA: leftWoodNode.physicsBody!, bodyB: self.physicsBody!, anchor: CGPoint.zero)
        scene.physicsWorld.add(baseJoint)

        let baseJoint2 = SKPhysicsJointFixed.joint(withBodyA: rightWoodNode.physicsBody!, bodyB: self.physicsBody!, anchor: CGPoint.zero)
        scene.physicsWorld.add(baseJoint2)
    }
    func interact() {
    }
    
}
