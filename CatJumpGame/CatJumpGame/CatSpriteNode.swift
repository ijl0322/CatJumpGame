//
//  CatSpriteNode.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 22/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//


enum CatType: Int, CustomStringConvertible {
    case unknown = 0, cat1, cat2
    
    init?(raw: Int) {
        self.init(rawValue: raw)
    }
    
    var spriteName: String {
        let spriteNames = ["unknown","cat1", "cat2"]
        return spriteNames[rawValue]
    }
    
    var body: String {
        return "\(spriteName)_body"
    }
    
    var head: String {
        return "\(spriteName)_head"
    }
    
    var eyes: String {
        return "\(spriteName)_blinking1"
    }
    
    var mouth: String {
        return "\(spriteName)_smile"
    }
    
    var feet: String {
        return "\(spriteName)_feet"
    }
    
    var tail: String {
        return "\(spriteName)_tail"
    }
    
    var description: String {
        return spriteName
    }
}


import SpriteKit
class CatSpriteNode: SKSpriteNode, EventListenerNode {
    var isPinned = false
    var bodyNode: SKSpriteNode!
    var headNode: SKSpriteNode!
    var eyesNode: SKSpriteNode!
    var mouthNode: SKSpriteNode!
    var feetNode: SKSpriteNode!
    var tailNode: SKSpriteNode!
    
    
    init(catType: CatType) {
        let size = CGSize(width: 330, height: 330)
        super.init(texture: nil, color: UIColor.red, size: size)
        bodyNode = SKSpriteNode(imageNamed: catType.body)
        bodyNode.position = CGPoint(x: 0, y: -80)
        self.addChild(bodyNode)
        
        headNode = SKSpriteNode(imageNamed: catType.head)
        headNode.position = CGPoint(x: 10.8, y: 136.5)
        headNode.zPosition = 1
        bodyNode.addChild(headNode)
        
        eyesNode = SKSpriteNode(imageNamed: catType.eyes)
        eyesNode.position = CGPoint(x: -3, y: -17)
        eyesNode.zPosition = 2
        headNode.addChild(eyesNode)
        
        mouthNode = SKSpriteNode(imageNamed: catType.mouth)
        mouthNode.position = CGPoint(x: -1.9, y: -63.5)
        mouthNode.zPosition = 2
        headNode.addChild(mouthNode)
        
        feetNode = SKSpriteNode(imageNamed: catType.feet)
        feetNode.position = CGPoint(x: 0, y: -40)
        feetNode.zPosition = 2
        bodyNode.addChild(feetNode)
        
        tailNode = SKSpriteNode(imageNamed: catType.tail)
        tailNode.position = CGPoint(x: -50, y: -45.5)
        tailNode.zPosition = 0
        tailNode.anchorPoint = CGPoint(x: 1, y: 0)
        bodyNode.addChild(tailNode)
        
        didMoveToScene()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didMoveToScene() {
        print("new cat added to scene")
        
        let catBodyTexture = SKTexture(imageNamed: "cat1_physics")
        physicsBody = SKPhysicsBody(texture: catBodyTexture,
                                            size: catBodyTexture.size())
        physicsBody?.categoryBitMask = PhysicsCategory.Cat1
        physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Obstacle | PhysicsCategory.Floor | PhysicsCategory.Floor
        physicsBody?.contactTestBitMask = PhysicsCategory.Bread | PhysicsCategory.LeftWood | PhysicsCategory.RightWood
        
        let rotationConstraint = SKConstraint.zRotation(
            SKRange(lowerLimit: -30.toRadians(), upperLimit: 30.toRadians()))
        self.constraints = [rotationConstraint]
    }
}
