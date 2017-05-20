//
//  BreadNode.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 18/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

enum BreadType {
    static let croissant: CGFloat = 10
}


import SpriteKit
class BreadNode: SKSpriteNode, EventListenerNode {
    var notAte = true
    var points = 10
    
    func didMoveToScene() {
        print("bread added to scene")

        let size = CGSize(width: self.frame.size.width/2, height: self.frame.size.height/2)
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.Bread
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.Cat1 | PhysicsCategory.Cat2
        
        let randomTime = CGFloat.random(min: 0.1, max: 0.5)
        let leftWiggle = SKAction.rotate(byAngle: 10.toRadians(), duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let pause = SKAction.wait(forDuration: TimeInterval(randomTime))
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle, pause])
        let wiggleForever = SKAction.repeatForever(fullWiggle)
        self.run(wiggleForever, withKey: "wiggle")
        
        findPoints()
    }
    
    func findPoints() {
        if let name = self.name {
            switch name {
            case "croissant":
                points = 20
                break
            default:
                return
            }
        }
    }
    
    func remove() -> Int{
        if notAte {
            print("Ate bread")
            print("Got points: \(points)")
            notAte = false
            //SKAction.playSoundFileNamed("pop.mp3",waitForCompletion: false),
            run(SKAction.sequence([
                SKAction.scale(to: 0.2, duration: 0.5),
                SKAction.removeFromParent()
            ]))
            return points
        }
        return 0
    }
}

