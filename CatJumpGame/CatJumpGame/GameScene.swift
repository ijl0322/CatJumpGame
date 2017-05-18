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
    static let Seesaw: UInt32 = 0b10 //2
    static let LeftWood: UInt32 = 0b100 //4
    static let RightWood: UInt32 = 0b1000 //8
}

protocol EventListenerNode {
    func didMoveToScene()
}
protocol InteractiveNode {
    func interact()
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var ballNode: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.width
            - maxAspectRatioHeight)/2
        let playableRect = CGRect(x:  192, y: 0,
                                  width: 1152, height: 2048)
        print(size.width)
        print(playableMargin)
        print(maxAspectRatioHeight)
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
        
        ballNode = childNode(withName: "ball") as! SKSpriteNode
        
        debugDrawPlayableArea(playableRect: playableRect)
        view.showsPhysics = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        ballNode?.position = touchLocation
        
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
