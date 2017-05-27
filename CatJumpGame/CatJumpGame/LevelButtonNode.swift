//
//  LevelButtonNode.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 27/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//


import SpriteKit
class LevelButtonNode: SKSpriteNode {
    
    var level = 0
    var starsNode: SKSpriteNode!
    var levelNumNode: MKOutlinedLabelNode!
    
    init(level: Int, levelCompleteType: LevelCompleteType) {
        let texture = SKTexture(imageNamed: "levelBaseButton")
        let size = CGSize(width: 150, height: 150)
        self.level = level
        super.init(texture: texture, color: UIColor.clear, size: size)
        
        let darkRed = UIColor(red: 188/255, green: 7/255, blue: 1/255, alpha: 1)
        levelNumNode = MKOutlinedLabelNode(fontNamed: "BradyBunchRemastered", fontSize: 96)
        levelNumNode.borderColor = darkRed
        levelNumNode.borderWidth = 10
        levelNumNode.borderOffset = CGPoint(x: -3, y: -3)
        levelNumNode.fontColor = UIColor.white
        levelNumNode.outlinedText = "\(level)"
        levelNumNode.zPosition = 10
        levelNumNode.position = CGPoint(x: 0,y: -30)
        addChild(levelNumNode)
        
        switch levelCompleteType {
        case .oneStar:
            starsNode = SKSpriteNode(imageNamed: "oneStar")
            starsNode.position = CGPoint(x: 0, y: -56.5)
            starsNode.zPosition = 1
            addChild(starsNode)
        default:
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
}
