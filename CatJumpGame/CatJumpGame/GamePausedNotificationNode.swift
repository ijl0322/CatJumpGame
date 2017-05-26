//
//  GamePausedNotificationNode.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 26/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import SpriteKit
class GamePausedNotificationNode: SKSpriteNode, EventListenerNode {
    
    var scoreLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 130)
    var timeLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 130)
    var coinsLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 130)
    var star1: SKSpriteNode!
    var star2: SKSpriteNode!
    var star3: SKSpriteNode!
    var levelsButton: SKSpriteNode!
    var replayButton: SKSpriteNode!
    var nextButton: SKSpriteNode!
    var leaderBoardButton: SKSpriteNode!
    var score = 0
    var levelStatus: LevelCompleteType = .lose
    
    
    init(score: Int, levelStatus: LevelCompleteType, time: Int) {
        let texture = SKTexture(imageNamed: "pausedNotification")
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 910, height: 800))
        self.position = CGPoint(x: 768, y: 1200)
        addButtons()
        didMoveToScene()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtons() {
        levelsButton = SKSpriteNode(imageNamed: ButtonName.levels)
        levelsButton.position = CGPoint(x: -310, y: -534)
        levelsButton.zPosition = 30
        levelsButton.name = ButtonName.levels
        
        addChild(levelsButton)
        
        replayButton = SKSpriteNode(imageNamed: ButtonName.replay)
        replayButton.position = CGPoint(x: -105, y: -534)
        replayButton.zPosition = 30
        replayButton.name = ButtonName.replay
        addChild(replayButton)
        
        nextButton = SKSpriteNode(imageNamed: ButtonName.next)
        nextButton.position = CGPoint(x: 105, y: -534)
        nextButton.zPosition = 30
        nextButton.name = ButtonName.next
        addChild(nextButton)
        
        leaderBoardButton = SKSpriteNode(imageNamed: ButtonName.leaderBoard)
        leaderBoardButton.position = CGPoint(x: 310, y: -534)
        leaderBoardButton.zPosition = 30
        leaderBoardButton.name = ButtonName.leaderBoard
        addChild(leaderBoardButton)
    }
    
    func didMoveToScene() {
        
    }
}

