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
    case initial=0, start, play, win, lose, reload, pause, end
}

class GameScene: SKScene, SKPhysicsContactDelegate{

    let TileWidth: CGFloat = 100.0
    let TileHeight: CGFloat = 100.0
    let space: CGFloat = 50.0
    var level = Level(num: 3)
    var scoreLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 80)
    var timeLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 80)
    var playableMargin: CGFloat = 0.0
    var seesawLeftBound: CGFloat = 0.0
    var seesawRightBound: CGFloat = 0.0
    var elapsedTime: Int = 0
    var startTime: Int?
    var timeLimit = 10
    var seesawNode: SeesawNode?
    var rightCatNode: CatSpriteNode!
    var leftCatNode: CatSpriteNode!
    var gameEndNotificationNode: GameEndNotificationNode?
    var pausedNotice: GamePausedNotificationNode?
    
    //Game State
    var score = 0
    var gameState: GameState = .initial
    
    override func didMove(to view: SKView) {
        if gameState == .initial {
            setUpScene(view: view)
        } else if gameState == .pause && seesawNode == nil{
            gameState = .reload
            pausedNotice = GamePausedNotificationNode()
            pausedNotice?.zPosition = 90
            addChild(pausedNotice!)
            addMKLabels()
            addCatAndSeesaw()
        }
    
        view.showsPhysics = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        reactToTouches(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        reactToTouches(touches: touches)
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
                print(level.levelCompleteStatus(score: score))
            }
        }
        
        if collision == PhysicsCategory.RightCat | PhysicsCategory.Floor {
            print("Cat fell!")
            
            if gameState == .play {
                gameState = .lose
                print(level.levelCompleteStatus(score: score))
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        print(gameState)
        
        if gameState == .play {
            checkGameState()
            updateTime(currentTime: currentTime)
        }
        
        if gameState == .pause || gameState == .reload {
            isPaused = true
            return
        }
        
        if gameState == .win {
            endGame()
            gameState = .end
            return
        }
        
        if gameState == .lose {
            seesawNode?.stopMovement()
            endGame()
            gameState = .end
            return
        }
    }
    
    //MARK: - Encode/Decoder
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(level.levelNum, forKey: "Scene.level")
        aCoder.encode(Float(playableMargin), forKey: "Scene.playableMargin")
        aCoder.encode(Float(seesawLeftBound), forKey: "Scene.seesawLeftBound")
        aCoder.encode(Float(seesawRightBound), forKey: "Scene.seesawRightBound")
        aCoder.encode(elapsedTime, forKey: "Scene.elapsedTime")
        aCoder.encode(timeLimit, forKey: "Scene.timeLimit")
        aCoder.encode(score, forKey: "Scene.score")
        aCoder.encode(gameState.rawValue,
                      forKey: "Scene.gameState")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let savedGameState = aDecoder.decodeInteger(
            forKey: "Scene.gameState")
        if let gameState = GameState(rawValue: savedGameState),
            gameState == .pause {
            self.gameState = gameState
            level = Level(num: aDecoder.decodeInteger(forKey: "Scene.level"))
            _ = level.loadBread()
            playableMargin = CGFloat(aDecoder.decodeFloat(forKey: "Scene.playableMargin"))
            seesawLeftBound = CGFloat(aDecoder.decodeFloat(forKey: "Scene.seesawLeftBound"))
            seesawRightBound = CGFloat(aDecoder.decodeFloat(forKey: "Scene.seesawRightBound"))
            elapsedTime = aDecoder.decodeInteger(forKey: "Scene.elapsedTime")
            timeLimit = aDecoder.decodeInteger(forKey: "Scene.timeLimit")
            score = aDecoder.decodeInteger(forKey: "Scene.score")
            scoreLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 80)
            timeLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 80)
        }
        
        addObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Game Helper Functions

extension GameScene {
    
    //Mark: - Game State Manegement Helper
    func endGame() {
        gameEndNotificationNode = GameEndNotificationNode(score: score, levelStatus: level.levelCompleteStatus(score: score), time: timeLimit - elapsedTime)
        gameEndNotificationNode?.zPosition = 150
        self.scene?.addChild(gameEndNotificationNode!)
        gameEndNotificationNode?.animateStarsReceived()
        gameEndNotificationNode?.animateBonus(time: timeLimit - elapsedTime)
    }
    
    func updateTime(currentTime: TimeInterval) {
        if let startTime = startTime {
            elapsedTime = Int(currentTime) - startTime
        } else {
            startTime = Int(currentTime) - elapsedTime
        }
        timeLabel.outlinedText = (timeLimit - elapsedTime).secondsToFormatedString()
    }
    
    func transitionToScene(level: Int) {
        print("Transitionaing to new scene")
        guard let newScene = SKScene(fileNamed: "GameScene")
            as? GameScene else {
                fatalError("Level: \(level) not found")
        }
        newScene.scaleMode = .aspectFill
        newScene.level = Level(num: level)
        view!.presentScene(newScene,
                           transition: SKTransition.flipVertical(withDuration: 0.5))
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
    
    func checkGameState() {
        
        if score >= level.highestScore {
            gameState = .win
        }
        
        if timeLimit - elapsedTime <= 0 {
            gameState = .lose
        }
    }
    
    //MARK: - Cat Animation Helper
    
    func eatBread(contact: SKPhysicsContact, catNode: CatSpriteNode?) {
        let breadNode = contact.bodyA.categoryBitMask ==
            PhysicsCategory.Bread ? contact.bodyA.node :
            contact.bodyB.node
        let breadAte = breadNode as? BreadNode
        catNode?.dropSlightly()
        score += (breadAte?.remove())!
        scoreLabel.borderOffset = CGPoint(x: 1, y: 1)
        scoreLabel.outlinedText = "\(score)"
        //print("My Score: \(score)")
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
    
    // MARK: - Bread Helper
    
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
    
    //MARK: - Game Scene Setup
    
    func setUpScene(view: SKView) {
        
        gameState = .start
        
        let maxAspectRatio: CGFloat = 9.0/16.0
        let maxAspectRatioWidth = size.height * maxAspectRatio
        playableMargin = (size.width
            - maxAspectRatioWidth)/2
        let playableRect = CGRect(x:  playableMargin, y: 0,
                                  width: maxAspectRatioWidth, height: size.height)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        
//        enumerateChildNodes(withName: "//*", using: { node, _ in
//            if let eventListenerNode = node as? EventListenerNode {
//                eventListenerNode.didMoveToScene()
//            }
//        })
        
        timeLimit = level.timeLimit
        
        addMKLabels()
        addCatAndSeesaw()
        
        let allBreads = level.loadBread()
        addBread(breads: allBreads)
    }
    
    func addCatAndSeesaw() {
        seesawNode = SeesawNode()
        seesawLeftBound = playableMargin + (seesawNode?.frame.width)!/2
        seesawRightBound = size.width - playableMargin - (seesawNode?.frame.width)!/2
        seesawNode?.physicsBody?.isDynamic = false
        self.scene?.addChild(seesawNode!)
        seesawNode?.didMoveToScene()
        
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
    }
    
    func addMKLabels() {
        scoreLabel.borderColor = UIColor.red
        scoreLabel.fontColor = UIColor.white
        scoreLabel.outlinedText = "\(score)"
        scoreLabel.zPosition = 15
        scoreLabel.position = CGPoint(x: 1217, y: 25)
        addChild(scoreLabel)
    
        timeLabel.borderColor = UIColor.red
        timeLabel.fontColor = UIColor.white
        timeLabel.outlinedText = timeLimit.secondsToFormatedString()
        timeLabel.zPosition = 15
        timeLabel.position = CGPoint(x: 364, y: 25)
        addChild(timeLabel)
    }
    
    //MARK: - Touches Helper
    
    func reactToTouches(touches: Set<UITouch>) {
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
        case .end:
            if let touchedNode =
                atPoint(touch.location(in: self)) as? SKSpriteNode {
                if touchedNode.name == ButtonName.replay {
                    transitionToScene(level: level.levelNum)
                }
            }
        case .reload:
            if let touchedNode =
                atPoint(touch.location(in: self)) as? SKSpriteNode {
                if touchedNode.name == ButtonName.yes {
                    print("Resume game")
                    pausedNotice?.removeFromParent()
                    isPaused = false
                    startTime = nil
                    gameState = .play
                } else if touchedNode.name == ButtonName.no {
                    transitionToScene(level: 2)
                }
            }
        default:
            return
        }
    }
}

//MARK: - Game State Handling

extension GameScene {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive),
                                               name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    func applicationDidBecomeActive() {
        if gameState == .pause {
            gameState = .reload
            pausedNotice = GamePausedNotificationNode()
            pausedNotice?.zPosition = 90
            addChild(pausedNotice!)
            addMKLabels()
            addCatAndSeesaw()
        }
    }
    
    func applicationWillResignActive() {
        
        isPaused = true
        if gameState == .play {
            gameState = .pause
            print("pausing game")
        }
    }
    
    func applicationDidEnterBackground() {
        if gameState == .pause {
            scoreLabel.removeFromParent()
            timeLabel.removeFromParent()
            leftCatNode.removeFromParent()
            rightCatNode.removeFromParent()
            seesawNode?.removeFromParent()
            seesawNode = nil
            print("Entering background")
            saveGame()
        }
    }
    
    func saveGame() {
        let fileManager = FileManager.default
        guard let directory =
            fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first else { return }
        let saveURL = directory.appendingPathComponent("SavedGames")
        do {
            try fileManager.createDirectory(atPath: saveURL.path,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        } catch let error as NSError {
            fatalError(
                "Failed to create directory: \(error.debugDescription)")
        }

        let fileURL = saveURL.appendingPathComponent("level\(level.levelNum)")
        print("* Saving: \(fileURL.path)")
        NSKeyedArchiver.archiveRootObject(self, toFile: fileURL.path)
    }
    
    class func loadLevel(num: Int) -> SKScene? {
        print("* loading game")
        var scene: SKScene?
        let fileManager = FileManager.default
        guard let directory =
            fileManager.urls(for: .libraryDirectory,
                             in: .userDomainMask).first
            else { return nil }
        let url = directory.appendingPathComponent(
            "SavedGames/level\(num)")
        if FileManager.default.fileExists(atPath: url.path) {
            scene = NSKeyedUnarchiver.unarchiveObject(
                withFile: url.path) as? GameScene
            _ = try? fileManager.removeItem(at: url)
        }
        return scene
    }
    
}
