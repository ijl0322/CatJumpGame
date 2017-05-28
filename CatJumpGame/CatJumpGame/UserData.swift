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
    var highScores = [0, 0, 0]
    var nickName = "Anonymous User"
    
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
    
    func updateHighScoreForLevel(_ num: Int, score: Int) {
        if num <= highScores.count {
            if highScores[num - 1] < score {
                highScores[num - 1] = score
                print("High Score for level \(num) is: \(highScores[num - 1])")
                saveToFirebase()
                defaults.set(highScores, forKey: "highScores")
            }
        } else {
            highScores.append(score)
            print("High Score for level \(num) is: \(highScores[num - 1])")
            saveToFirebase()
            defaults.set(highScores, forKey: "highScores")
        }
    }
    
    func toAnyObject() -> [String: Any]{
        return ["nickName": nickName, "highScores": highScores]
    }
    
    func saveToFirebase() {
        FirebaseManager.sharedInstance.updateUserData(data: ["nickName": nickName, "highScores": highScores])
    }
    
}
