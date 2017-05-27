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
    let id = UIDevice().identifierForVendor?.uuidString
    var highScores = [0, 0, 0]
    var nickName = "Anonymous User"
    
    func highScoreForLevel(_ num: Int) -> Int? {
        if num <= highScores.count {
            return highScores[num - 1]
        }
        return nil
    }
    
    func updateHighScoreForLevel(_ num: Int, score: Int) {
        if num <= highScores.count {
            if highScores[num - 1] < score {
                highScores[num - 1] = score
                 print("High Score for level \(num) is: \(highScores[num - 1])")
            }
        } else {
            highScores.append(score)
            print("High Score for level \(num) is: \(highScores[num - 1])")
        }
       
    }
}
