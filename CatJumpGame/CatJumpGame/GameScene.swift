//
//  GameScene.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 16/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None:  UInt32 = 0
    static let Edge: UInt32 = 0b1  //1
    static let Obstacle: UInt32 = 0b10 //2
    static let LeftWood: UInt32 = 0b100 //4
    static let RightWood: UInt32 = 0b1000 //8
    static let Cat1: UInt32 = 0b10000 //16
    static let Cat2: UInt32 = 0b100000 //32
    static let Bread: UInt32 = 0b1000000 //64
    static let LeftWoodBound: UInt32 = 0b10000000 //128
}

protocol EventListenerNode {
    func didMoveToScene()
}
protocol InteractiveNode {
    func interact()
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var ballNode: SKSpriteNode?
    var seesawBaseNode: SeesawBaseNode?
    var cat1Node: CatNode?
    var score = 0
    
    override func didMove(to view: SKView) {
        
        let maxAspectRatio: CGFloat = 9.0/16.0
        let maxAspectRatioWidth = size.height * maxAspectRatio
        let playableMargin: CGFloat = (size.width
            - maxAspectRatioWidth)/2
        let playableRect = CGRect(x:  playableMargin, y: 0,
                                  width: maxAspectRatioWidth, height: size.height)

        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
        
        ballNode = childNode(withName: "ball") as? SKSpriteNode
        seesawBaseNode = childNode(withName: "seesawBase") as? SeesawBaseNode
        cat1Node = childNode(withName: "//cat1_body") as? CatNode

        
        debugDrawPlayableArea(playableRect: playableRect)
        view.showsPhysics = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        ballNode?.position = touchLocation
        
        //cat1Node?.gravityLess()
        //seesawBaseNode?.bounce()
        print("Disabling the contact")
        seesawBaseNode?.physicsBody?.contactTestBitMask = 0
        cat1Node?.parent!.physicsBody?.contactTestBitMask = PhysicsCategory.Bread
        seesawBaseNode?.releaseCat()
        cat1Node?.throwCat()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            print("Enabling the contact")
            self.seesawBaseNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Cat1
            self.cat1Node?.parent!.physicsBody?.contactTestBitMask = PhysicsCategory.Bread | PhysicsCategory.LeftWood
        })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask
            | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Cat1 | PhysicsCategory.Bread {
            let breadNode = contact.bodyA.categoryBitMask ==
                PhysicsCategory.Bread ? contact.bodyA.node :
                contact.bodyB.node
            let breadAte = breadNode as? BreadNode
            score += (breadAte?.remove())!
            print("My Score: \(score)")
        }
        
        if collision == PhysicsCategory.Cat1 | PhysicsCategory.LeftWood {
            cat1Node?.zRotation = 0
            cat1Node?.parent?.position = CGPoint(x: (cat1Node?.parent?.position.x)! ,y: (cat1Node?.parent?.position.y)! - 60)
            seesawBaseNode?.zRotation = 0
            seesawBaseNode?.fixCat(catPhysicsBody: (cat1Node?.parent?.physicsBody!)!)
            //cat1Node?.parent!.physicsBody!.isDynamic = false
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        //let collision = contact.bodyA.categoryBitMask
          //  | contact.bodyB.categoryBitMask

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
    
    func debugDrawPlayableArea(playableRect: CGRect) {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 10.0
        addChild(shape)
    }
}
