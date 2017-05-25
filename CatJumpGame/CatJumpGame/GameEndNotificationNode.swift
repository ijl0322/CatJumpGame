//
//  GameEndNotificationNode.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 25/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import SpriteKit
class GameEndNotificationNode: SKSpriteNode, EventListenerNode {
    
    var scoreLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 130)
    var timeLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 130)
    var coinsLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 130)
    
    init(score: Int, levelSatus: LevelCompleteType) {
        let texture = SKTexture(imageNamed: "levelComplete")
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 910, height: 1270))
        self.position = CGPoint(x: 768, y: 1000)
        addCoinsLabel(coins: levelSatus.coins)
        addScoreLabel(score: score)
        addTimeLabel(time: 100)
        
        didMoveToScene()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addScoreLabel(score: Int) {
        scoreLabel.borderWidth = 10
        scoreLabel.borderOffset = CGPoint(x: -3, y: -3)
        scoreLabel.borderColor = UIColor.red
        scoreLabel.fontColor = UIColor.white
        scoreLabel.outlinedText = "\(score)"
        scoreLabel.zPosition = 15
        scoreLabel.position = CGPoint(x: 143, y: -327)
        addChild(scoreLabel)
    }
    
    func addTimeLabel(time: Int) {
        
        let formattedTime = time.secondsToFormatedString()
        timeLabel.borderWidth = 10
        timeLabel.borderOffset = CGPoint(x: -3, y: -3)
        timeLabel.borderColor = UIColor.red
        timeLabel.fontColor = UIColor.white
        timeLabel.outlinedText = formattedTime
        timeLabel.zPosition = 15
        timeLabel.position = CGPoint(x: 208, y: -140)
        addChild(timeLabel)
    }
    
    func addCoinsLabel(coins: Int) {
        coinsLabel.borderWidth = 10
        coinsLabel.borderOffset = CGPoint(x: -3, y: -3)
        coinsLabel.borderColor = UIColor.red
        coinsLabel.fontColor = UIColor.white
        coinsLabel.outlinedText = "\(coins)"
        coinsLabel.zPosition = 15
        coinsLabel.position = CGPoint(x: 188, y: 42)
        addChild(coinsLabel)
    }
    
    func didMoveToScene() {

    }
}
