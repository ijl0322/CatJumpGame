//
//  CatSpriteNode.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 22/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

enum SeatSide: Int {
    case left = 0, right
    
    init?(raw: Int) {
        self.init(rawValue: raw)
    }
    
    var physicsBody: SKTexture {
        let physicsBodyImage = ["leftCat_physics", "leftCat_physics"]
        return SKTexture(imageNamed: physicsBodyImage[rawValue])
    }
}

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
    
    var blink: [SKTexture] {
        var textures:[SKTexture] = []
        for i in 1...3 {
            textures.append(SKTexture(imageNamed: "\(spriteName)_blinking\(i)"))
        }
        textures.append(SKTexture(imageNamed: "\(spriteName)_blinking\(1)"))
        return textures
    }
    
    var description: String {
        return spriteName
    }
}


import SpriteKit
class CatSpriteNode: SKSpriteNode, EventListenerNode {
    var isPinned = false
    var catType: CatType!
    var seatSide: SeatSide!
    
    // Nodes
    var bodyNode: SKSpriteNode!
    var headNode: SKSpriteNode!
    var eyesNode: SKSpriteNode!
    var mouthNode: SKSpriteNode!
    var feetNode: SKSpriteNode!
    var tailNode: SKSpriteNode!
    

    // MARK: - Initialization
    
    init(catType: CatType, isLeftCat: Bool) {
        let size = CGSize(width: 330, height: 330)
        self.catType = catType
        
        super.init(texture: nil, color: UIColor.clear, size: size)
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
        tailNode.zPosition = -1
        tailNode.anchorPoint = CGPoint(x: 1, y: 0)
        bodyNode.addChild(tailNode)
        
        if isLeftCat {
            seatSide = .left
        } else {
            seatSide = .right
        }
        
        didMoveToScene()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didMoveToScene() {
        print("new cat added to scene")
        
        let catBodyTexture = seatSide.physicsBody
        physicsBody = SKPhysicsBody(texture: catBodyTexture,
                                            size: catBodyTexture.size())
        
        physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Obstacle | PhysicsCategory.Floor | PhysicsCategory.RightCat | PhysicsCategory.LeftCat
        
        if seatSide == .left {
            physicsBody?.categoryBitMask = PhysicsCategory.LeftCat
            physicsBody?.contactTestBitMask = PhysicsCategory.Bread | PhysicsCategory.LeftWood
        } else {
            physicsBody?.categoryBitMask = PhysicsCategory.RightCat
            physicsBody?.contactTestBitMask = PhysicsCategory.Bread | PhysicsCategory.RightWood
            self.xScale = -1
        }
        
        let rotationConstraint = SKConstraint.zRotation(
            SKRange(lowerLimit: -30.toRadians(), upperLimit: 30.toRadians()))
        self.constraints = [rotationConstraint]
        
        normalStateAnimation()
    }
    
    //MARK: - Actions
    
    func jump() {
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5000))
    }
    
    func dropSlightly() {
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: -300))
    }
    
    //MARK: - Animations
    
    func normalStateAnimation() {
        
        // Eyes
        
        let textures = self.catType.blink
        let blinkAnimation = SKAction.animate(with: textures,
                                           timePerFrame: 0.1)
        let waitAnimation = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([blinkAnimation, blinkAnimation, waitAnimation])
        eyesNode.run(SKAction.repeatForever(sequence), withKey: "normal-eyes")
        
        
        // Tail
        
        let tailWaitAnimation = SKAction.wait(forDuration: 2)
        let tailRotationAnimation = SKAction.rotate(byAngle: 7.toRadians(), duration: 1.5)
        let tailRotationReversed = tailRotationAnimation.reversed()
        let fullTailAnimation = SKAction.sequence([tailWaitAnimation, tailRotationAnimation,
                                                   tailRotationReversed])
        tailNode.run(SKAction.repeatForever(fullTailAnimation), withKey: "normal-tail")
        
        
        // Mouth
        
        let mouthWaitAnimation = SKAction.wait(forDuration: 1.5)
        let mouthMoveAnimation = SKAction.moveBy(x: 0, y: -3, duration: 0.2)
        let mouthMoveReversed = mouthMoveAnimation.reversed()
        
        let fullMouthAnimation = SKAction.sequence([mouthWaitAnimation, mouthMoveAnimation,
                                                    mouthMoveReversed, mouthWaitAnimation])
        mouthNode.run(SKAction.repeatForever(fullMouthAnimation), withKey: "normal-mouth")
        
        // Body
        
        let bodyBounceAnimation = SKAction.moveBy(x: 0, y: 5, duration: 0.5)
        let bodyBounceReversed = bodyBounceAnimation.reversed()
        let fullBodyAnimation = SKAction.sequence([bodyBounceAnimation, bodyBounceReversed])
        
        bodyNode.run(SKAction.repeatForever(fullBodyAnimation), withKey: "normal-body")
        
        // Feet
        let feetBounceAnimation = SKAction.moveBy(x: 0, y: -5, duration: 0.5)
        let feetBounceReversed = feetBounceAnimation.reversed()
        let fullfeetAnimation = SKAction.sequence([feetBounceAnimation, feetBounceReversed])
        
        feetNode.run(SKAction.repeatForever(fullfeetAnimation), withKey: "normal-feet")
    }
}
