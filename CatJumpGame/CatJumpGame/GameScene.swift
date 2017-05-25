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

enum GameState: Int {
    case initial=0, start, play, win, lose, reload, pause
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
    let level = Level(filename: "Level_2")
    let scoreLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 80)
    var playableMargin: CGFloat = 0.0
    var seesawLeftBound: CGFloat = 0.0
    var seesawRightBound: CGFloat = 0.0
    var ballNode: SKSpriteNode?
    var seesawNode: SeesawNode?
    var rightCatNode: CatSpriteNode!
    var leftCatNode: CatSpriteNode!
    var gameEndNotificationNode: GameEndNotificationNode?
    
    //Game State
    var score = 0
    var gameState: GameState = .start

    
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
        
        seesawNode = childNode(withName: "seesaw") as? SeesawNode
        seesawLeftBound = playableMargin + (seesawNode?.frame.width)!/2
        seesawRightBound = size.width - playableMargin - (seesawNode?.frame.width)!/2
        seesawNode?.physicsBody?.isDynamic = false
        
        let rightCatxPosition = (seesawNode?.position.x)! + ((seesawNode?.frame.width)!/4)
        let leftCatxPosition = (seesawNode?.position.x)! - ((seesawNode?.frame.width)!/4)
        let catyPosition = (seesawNode?.position.y)! + (330)/2
       
        rightCatNode = CatSpriteNode(catType: .cat2, isLeftCat: false)
        rightCatNode.position = CGPoint(x: rightCatxPosition, y: catyPosition)
        rightCatNode.zPosition = 20
        self.scene?.addChild(rightCatNode)


        leftCatNode = CatSpriteNode(catType: .cat1, isLeftCat: true)
        leftCatNode.position = CGPoint(x: leftCatxPosition, y: catyPosition)
        leftCatNode.zPosition = 30
        self.scene?.addChild(leftCatNode)


        let allBreads = level.loadBread()
        addBread(breads: allBreads)
        
//        let livesLabel = SKLabelNode(fontNamed: "Brady Bunch Remastered")
//        livesLabel.text = "9999"
//        livesLabel.fontColor = SKColor.black
//        livesLabel.fontSize = 80
//        livesLabel.zPosition = 150
//        livesLabel.position = CGPoint(x: 1217, y: 25)
//        addChild(livesLabel)
        
        scoreLabel.borderColor = UIColor.red
        scoreLabel.fontColor = UIColor.white
        scoreLabel.outlinedText = "\(score)"
        scoreLabel.zPosition = 15
        scoreLabel.position = CGPoint(x: 1217, y: 25)
        addChild(scoreLabel)
        
        //MARK: - Debug
        
        //debugDrawPlayableArea(playableRect: playableRect)
        view.showsPhysics = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let touchLocation = touch.location(in: self)
        
        switch gameState {
        case .start:
            seesawNode?.physicsBody?.isDynamic = true
            gameState = .play
            isPaused = false
            seesawNode?.fixCat(catNode: rightCatNode)
            releaseCat(catNode: leftCatNode)
        case .play:
            seesawNode?.moveWithinBounds(targetLocation: touchLocation.x, leftBound: seesawLeftBound,
                                         rightBound: seesawRightBound)
        case .lose:
            seesawNode?.physicsBody?.isDynamic = false
        default:
            return
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        switch gameState {
        case .start:
            seesawNode?.physicsBody?.isDynamic = true
            gameState = .play
            isPaused = false
        case .play:
            seesawNode?.moveWithinBounds(targetLocation: touchLocation.x, leftBound: seesawLeftBound,
                                         rightBound: seesawRightBound)
        default:
            return
        }
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
        
        if gameState != .play {
            return
        }
        
        let collision = contact.bodyA.categoryBitMask
            | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.LeftCat | PhysicsCategory.Bread {
            eatBread(contact: contact, catNode: leftCatNode)
        }
        
        if collision == PhysicsCategory.RightCat | PhysicsCategory.Bread {
            eatBread(contact: contact, catNode: rightCatNode)
        }
        
        if collision == PhysicsCategory.LeftCat | PhysicsCategory.LeftWood {
            fixCat(catSeatSide: .left)
            releaseCat(catNode: rightCatNode)
        }
        
        if collision == PhysicsCategory.RightCat | PhysicsCategory.RightWood {
            fixCat(catSeatSide: .right)
            releaseCat(catNode: leftCatNode)
        }
        
        if collision == PhysicsCategory.LeftCat | PhysicsCategory.Floor {
            print("Cat fell!")
            if gameState == .play {
                gameState = .lose
                displayLose()
                print(level.levelCompleteStatus(score: score))
            }
        }
        
        if collision == PhysicsCategory.RightCat | PhysicsCategory.Floor {
            print("Cat fell!")
            
            if gameState == .play {
                gameState = .lose
                displayLose()
                print(level.levelCompleteStatus(score: score))
            }
        }
        
//        if collision == PhysicsCategory.LeftCat | PhysicsCategory.RightCat {
//            print("Cats collided")
//            switch (seesawNode?.catInTheAir())!{
//            case .left:
//                print("left cat jump")
//                //leftCatNode.bounceOff()
//            case .right:
//                print("right cat bounce")
//                //rightCatNode.bounceOff()
//            case .both:
//                return
//            }
//        }
    }
    
    func displayLose() {
        gameEndNotificationNode = GameEndNotificationNode(score: score, levelSatus: level.levelCompleteStatus(score: score))
        gameEndNotificationNode?.zPosition = 150
        self.scene?.addChild(gameEndNotificationNode!)
    }
    
    func eatBread(contact: SKPhysicsContact, catNode: CatSpriteNode?) {
        let breadNode = contact.bodyA.categoryBitMask ==
            PhysicsCategory.Bread ? contact.bodyA.node :
            contact.bodyB.node
        let breadAte = breadNode as? BreadNode
        catNode?.dropSlightly()
        score += (breadAte?.remove())!
        scoreLabel.outlinedText = "\(score)"
        
        //print("My Score: \(score)")
    }
    
    func fixCat(catSeatSide: SeatSide) {
        switch catSeatSide {
        case .left:
            let xPosition = (seesawNode?.position.x)! - ((seesawNode?.frame.width)!/4)
            let yPosition = (seesawNode?.position.y)! + (leftCatNode.frame.height)/2.5
            leftCatNode?.position = CGPoint(x: xPosition, y: yPosition)
            leftCatNode.canJump = true
            seesawNode?.fixCat(catNode: leftCatNode!)
        case .right:
            let xPosition = (seesawNode?.position.x)! + ((seesawNode?.frame.width)!/4)
            let yPosition = (seesawNode?.position.y)! + (rightCatNode.frame.height)/2.5
            rightCatNode?.position = CGPoint(x: xPosition, y: yPosition)
            rightCatNode.canJump = true
            seesawNode?.fixCat(catNode: rightCatNode!)
        default:
            return
        }
    }
    
    func releaseCat(catNode: CatSpriteNode) {
        
        catNode.disableSeesawContact()
        seesawNode?.releaseCat(catSide: catNode.seatSide)
        if catNode.canJump {
            catNode.jump()
            catNode.canJump = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            //print("Enabling the contact")
            catNode.enableSeesawContact()
        })
    }
    
    func didEnd(_ contact: SKPhysicsContact) {

    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameState == .pause {
            isPaused = true
            return
        }
        
        if score >= level.highestScore {
            print("You win!")
        }
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
