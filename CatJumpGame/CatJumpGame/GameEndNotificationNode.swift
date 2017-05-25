//
//  GameEndNotificationNode.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 25/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import SpriteKit
class GameEndNotificationNode: SKSpriteNode, EventListenerNode {
    
    var scoreLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 144)
    var timeLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 144)
    var coinsLabel = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 144)
    
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
        scoreLabel.borderColor = UIColor.red
        scoreLabel.fontColor = UIColor.white
        scoreLabel.outlinedText = "\(score)"
        scoreLabel.zPosition = 15
        scoreLabel.position = CGPoint(x: 143, y: -334)
        addChild(scoreLabel)
    }
    
    func addTimeLabel(time: Int) {
        timeLabel.borderColor = UIColor.red
        timeLabel.fontColor = UIColor.white
        timeLabel.outlinedText = "\(time)"
        timeLabel.zPosition = 15
        timeLabel.position = CGPoint(x: 208, y: -147)
        addChild(timeLabel)
    }
    
    func addCoinsLabel(coins: Int) {
        coinsLabel.borderColor = UIColor.red
        coinsLabel.fontColor = UIColor.white
        coinsLabel.outlinedText = "\(coins)"
        coinsLabel.zPosition = 15
        coinsLabel.position = CGPoint(x: 188, y: 36)
        addChild(coinsLabel)
    }
    
    func didMoveToScene() {

    }
}
