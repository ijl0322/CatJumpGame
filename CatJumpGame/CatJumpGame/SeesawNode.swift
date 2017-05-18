//
//  SeesawNode.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 17/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import SpriteKit
class SeesawNode: SKSpriteNode, EventListenerNode,
InteractiveNode {
    
    static func makeCompoundNode(in scene: SKScene) -> SKNode {
        let compound = SeesawNode()
        for piece in scene.children.filter(
            { node in node is SeesawNode}) {
                piece.removeFromParent()
                compound.addChild(piece)
        }
        
        var bodies: [SKPhysicsBody] = []
        
        for child in compound.children {
            if child.name == "log" {
                bodies.append(SKPhysicsBody(circleOfRadius: child.frame.size.width/2))
            } else {
                bodies.append(SKPhysicsBody(rectangleOf: child.frame.size, center: child.position))
            }
        }
        print(bodies.count)
        compound.physicsBody = SKPhysicsBody(bodies: bodies)
        compound.physicsBody!.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Seesaw
        compound.physicsBody!.categoryBitMask = PhysicsCategory.Seesaw
        compound.physicsBody!.isDynamic = true
        compound.isUserInteractionEnabled = true
        compound.zPosition = 1
        return compound
    }
    
    func didMoveToScene() {
        guard let scene = scene else {
            return
        }
        if parent == scene {
            scene.addChild(SeesawNode.makeCompoundNode(in: scene))
        }
        
        print("Seesaw added to scene")
    }
    func interact() {
    }

}
