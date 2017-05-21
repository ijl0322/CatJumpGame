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
    
    private var leftWoodNode = SKSpriteNode(imageNamed: "leftWood")
    private var rightWoodNode = SKSpriteNode(imageNamed: "rightWood")
    private var leftContactPointNode = SKSpriteNode()
    private var rightContactPointNode = SKSpriteNode()
    var cat1Joint: SKPhysicsJointFixed?
    var catSpringJoint: SKPhysicsJointSpring?
    var cat1Fixed: Bool {
        return cat1Joint != nil
    }
    
    func didMoveToScene() {
        guard let scene = scene else {
            return
        }
        
        leftWoodNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leftWoodNode.position = CGPoint(x: -leftWoodNode.size.width/2, y: leftWoodNode.size.height)
        leftWoodNode.physicsBody = SKPhysicsBody(rectangleOf: leftWoodNode.frame.size)
        leftWoodNode.physicsBody?.affectedByGravity = true
        leftWoodNode.physicsBody?.isDynamic = true
        leftWoodNode.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        leftWoodNode.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Obstacle
        self.addChild(leftWoodNode)
        
        leftContactPointNode.size = CGSize(width: 30, height: 10)
        leftContactPointNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leftContactPointNode.position = CGPoint(x: -leftWoodNode.frame.size.width/2, y: leftWoodNode.frame.size.height)
        leftContactPointNode.physicsBody = SKPhysicsBody(rectangleOf: leftContactPointNode.frame.size)
        self.addChild(leftContactPointNode)
        leftContactPointNode.physicsBody?.categoryBitMask = PhysicsCategory.LeftWood
        leftContactPointNode.physicsBody?.collisionBitMask = 0

        let edgeJoint = SKPhysicsJointFixed.joint(withBodyA: leftWoodNode.physicsBody!, bodyB: leftContactPointNode.physicsBody!, anchor: CGPoint.zero)
        scene.physicsWorld.add(edgeJoint)
        
        rightWoodNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rightWoodNode.position = CGPoint(x: rightWoodNode.size.width/2, y: rightWoodNode.size.height)
        rightWoodNode.physicsBody = SKPhysicsBody(rectangleOf: rightWoodNode.frame.size)
        rightWoodNode.physicsBody?.affectedByGravity = true
        rightWoodNode.physicsBody?.isDynamic = true
        rightWoodNode.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        rightWoodNode.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Obstacle
        self.addChild(rightWoodNode)
        
        let woodJoint = SKPhysicsJointFixed.joint(withBodyA: leftWoodNode.physicsBody!, bodyB: rightWoodNode.physicsBody!, anchor: CGPoint.zero)
        scene.physicsWorld.add(woodJoint)
        
        let baseJoint = SKPhysicsJointFixed.joint(withBodyA: leftWoodNode.physicsBody!, bodyB: self.physicsBody!, anchor: CGPoint.zero)
        scene.physicsWorld.add(baseJoint)

        let baseJoint2 = SKPhysicsJointFixed.joint(withBodyA: rightWoodNode.physicsBody!, bodyB: self.physicsBody!, anchor: CGPoint.zero)
        scene.physicsWorld.add(baseJoint2)
    }
    
    func bounce() {
        leftWoodNode.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 400),
                                               at: CGPoint(x: size.width/2, y: size.height))
        //releaseCat()
        

    }
    
    func fixCat(catPhysicsBody: SKPhysicsBody) {
        guard let scene = scene else {
            return
        }
        
        if !cat1Fixed{
            let pinPoint = CGPoint(
                x: leftWoodNode.position.x,
                y: leftWoodNode.position.y * 2)
            cat1Joint = SKPhysicsJointFixed.joint(withBodyA: leftWoodNode.physicsBody!, bodyB: catPhysicsBody, anchor: pinPoint)
            scene.physicsWorld.add(cat1Joint!)
        }
    }
    
    func releaseCat() {
        if cat1Fixed {
            scene!.physicsWorld.remove(cat1Joint!)
            cat1Joint = nil
        }
    }
    
    func interact() {
    }
    
}
