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
        seesawBaseNode?.bounce()
        
        
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
