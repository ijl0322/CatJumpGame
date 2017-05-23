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
    static let LeftCat: UInt32 = 0b10000 //16
    static let RightCat: UInt32 = 0b100000 //32
    static let Bread: UInt32 = 0b1000000 //64
    static let Floor: UInt32 = 0b10000000 //128
}

protocol EventListenerNode {
    func didMoveToScene()
}
protocol InteractiveNode {
    func interact()
}

class GameScene: SKScene, SKPhysicsContactDelegate{

    let TileWidth: CGFloat = 100.0
    let TileHeight: CGFloat = 100.0
    let space: CGFloat = 50.0
    let level = Level(filename: "Level_1")
    var playableMargin: CGFloat = 0.0
    var ballNode: SKSpriteNode?
    var seesawNode: SeesawNode?
    var cat1Node: CatNode?
    var catTestNode: CatSpriteNode?
    var testBread: BreadNode?
    var score = 0
    
    override func didMove(to view: SKView) {
        
        let maxAspectRatio: CGFloat = 9.0/16.0
        let maxAspectRatioWidth = size.height * maxAspectRatio
        playableMargin = (size.width
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
        
        catTestNode = CatSpriteNode(catType: .cat1, isLeftCat: false)
        catTestNode?.position = CGPoint(x: 500, y: 500)
        catTestNode?.zPosition = 100
        self.scene?.addChild((catTestNode)!)
        
        
        ballNode = childNode(withName: "ball") as? SKSpriteNode
        seesawNode = childNode(withName: "seesaw") as? SeesawNode
        cat1Node = childNode(withName: "//cat1_body") as? CatNode
        cat1Node?.parent?.physicsBody?.isDynamic = false

        let allBreads = level.loadBread()
        addBread(breads: allBreads)
        
        debugDrawPlayableArea(playableRect: playableRect)
        view.showsPhysics = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        //ballNode?.position = touchLocation
        
        seesawNode?.position.x = touchLocation.x
        releaseCat()
        catTestNode?.jump()
    }
    
    func addBread(breads: Set<Bread>) {
        for bread in breads {
            let size = CGSize(width: TileWidth, height: TileHeight)
            let sprite = BreadNode(size: size, breadType: bread.breadType)
            sprite.position = pointFor(column: bread.column, row: bread.row)
            self.scene?.addChild(sprite)
            bread.sprite = sprite
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*(TileWidth + space) + TileWidth/2 + playableMargin,
            y: CGFloat(row)*TileHeight + TileHeight/2 + size.height/2)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask
            | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.LeftCat | PhysicsCategory.Bread {
            let breadNode = contact.bodyA.categoryBitMask ==
                PhysicsCategory.Bread ? contact.bodyA.node :
                contact.bodyB.node
            let breadAte = breadNode as? BreadNode
            cat1Node?.dropSlightly()
            score += (breadAte?.remove())!
            print("My Score: \(score)")
        }
        
        if collision == PhysicsCategory.LeftCat | PhysicsCategory.LeftWood {
            
            //cat1Node?.parent?.position = CGPoint(x: (cat1Node?.parent?.position.x)! ,y: 0)
            //seesawNode?.fixCat(catNode: cat1Node!)
            //print(catTestNode?.position.y)
            //print(seesawNode?.position.y)
            
            let xPosition = (seesawNode?.position.x)! - ((seesawNode?.frame.width)!/4)
            let yPosition = (seesawNode?.position.y)! + (catTestNode?.frame.height)!/2.5
            catTestNode?.position = CGPoint(x: xPosition, y: yPosition)
            seesawNode?.fixCat(catNode: catTestNode!)
        }
        
        if collision == PhysicsCategory.LeftCat | PhysicsCategory.Floor {
            print("Cat fell!")
        }
    }
    
    func releaseCat() {
//        print("Disabling the contact")
//        seesawNode?.physicsBody?.contactTestBitMask = 0
//        cat1Node?.parent!.physicsBody?.contactTestBitMask = PhysicsCategory.Bread
//        seesawNode?.releaseCat()
//        seesawNode?.physicsBody?.isDynamic = true
//        cat1Node?.throwCat()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//            print("Enabling the contact")
//            self.seesawNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Cat1
//            self.cat1Node?.parent!.physicsBody?.contactTestBitMask = PhysicsCategory.Bread | PhysicsCategory.LeftWood
//        })
        
        
        catTestNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Bread
        seesawNode?.releaseCat()
        catTestNode?.jump()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            print("Enabling the contact")
            self.catTestNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Bread | PhysicsCategory.LeftWood
        })
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
