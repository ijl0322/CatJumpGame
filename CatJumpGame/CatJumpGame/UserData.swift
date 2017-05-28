//
//  UserData.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 27/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import Foundation
import UIKit

class UserData {
    static let shared = UserData()
    let defaults = UserDefaults.standard
    var highScores = [0]
    var levelStatus: [LevelCompleteType] = [.lose]
    var nickName = "Anonymous User"
    var coins = 0
    var unlockedLevels: Int {
        return highScores.count
    }
    
    init() {
        if let nickName = defaults.object(forKey: "nickName") as? String {
            self.nickName = nickName
            print("Getting from user defaults")
        } else {
            defaults.set(nickName, forKey: "nickName")
        }
        
        if let highScores = defaults.array(forKey: "highScores") as? [Int] {
            self.highScores = highScores
        } else {
            defaults.set(highScores, forKey: "highScores")
        }
        
        if let levelStatusRaw = defaults.array(forKey: "levelStatus") as? [Int] {
            self.levelStatus = rawToLevelStatus(raw: levelStatusRaw)
        } else {
            defaults.set(levelStatusToRaw(), forKey: "levelStatus")
        }
    }
        
    func getDataFromFirebase() {
        FirebaseManager.sharedInstance.getUserData(completion: { (snapshot) in
            self.nickName = snapshot["nickName"] as! String
            self.highScores = snapshot["highScores"] as! [Int]
            print("User init from firebase")
        })
    }
    
    func highScoreForLevel(_ num: Int) -> Int? {
        if num <= highScores.count {
            return highScores[num - 1]
        }
        return nil
    }
    
    func changeNickname(name: String) {
        nickName = name
        defaults.set(nickName, forKey: "nickName")
    }
    
    func levelStatusToRaw() -> [Int]{
        let newLevelStatusArray = levelStatus.map({ (value: LevelCompleteType) -> Int in
            return value.rawValue
        })
        return newLevelStatusArray
    }
    
    func rawToLevelStatus(raw: [Int]) -> [LevelCompleteType] {
        let newLevelStatus = raw.map({ (value: Int) -> LevelCompleteType in
            return LevelCompleteType.init(raw: value)!
        })
        return newLevelStatus
    }
    
    func updateHighScoreForLevel(_ num: Int, score: Int, levelCompleteType: LevelCompleteType) {
        print("Updating user high score")

        if num <= highScores.count {
            if highScores[num - 1] < score {
                highScores[num - 1] = score
                levelStatus[num - 1] = levelCompleteType
                print("High Score for level \(num) is: \(highScores[num - 1])")
                saveToFirebase()
            }
        } else {
            highScores.append(score)
            print("High Score for level \(num) is: \(highScores[num - 1])")
            levelStatus[num - 1] = levelCompleteType
            saveToFirebase()
        }
        
        if levelCompleteType != .lose && num == highScores.count{
            print("unlocking a new level")
            highScores.append(0)
            levelStatus.append(.lose)
        }
        defaults.set(highScores, forKey: "highScores")
        defaults.set(levelStatusToRaw(), forKey: "levelStatus")
    }
    
    func toAnyObject() -> [String: Any]{
        return ["nickName": nickName, "highScores": highScores]
    }
    
    func saveToFirebase() {
        let newLevelStatus = levelStatusToRaw()
        FirebaseManager.sharedInstance.updateUserData(data: ["nickName": nickName, "highScores": highScores, "levelStatus" : newLevelStatus])
    }
    
}
