//
//  FirebaseManager.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 27/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import Firebase
import UIKit

class FirebaseManager {
    static let sharedInstance = FirebaseManager()
    let levelsRef = FIRDatabase.database().reference(withPath: "levels")
    let userDataRef = FIRDatabase.database().reference(withPath: "users")
    let highScoreDataRef = FIRDatabase.database().reference(withPath: "highScores")
    let id = UIDevice().identifierForVendor?.uuidString
    
    func loadAllLevels() {
        levelsRef.observeSingleEvent(of: .value, with: { snapshot in
            //print(snapshot)
            let levels = snapshot.value as! [[String: Any]]
            dump(levels.count)
            for (index, levelData) in levels.enumerated() {
                self.saveToDoc(levelData: levelData, level: index + 1)
            }
        })
    }
    
    func loadLevel(num: Int) {
        levelsRef.child("\(num)").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot)
            let level = snapshot.value as! [String: Any]
            self.saveToDoc(levelData: level, level: num)
        })
    }
    
    func updateUserData(data: [String:Any]) {
        userDataRef.child(id!).setValue(data)
    }
    
    func getUserData(completion: @escaping ([String:Any]) -> Void) {
        userDataRef.child(id!).observeSingleEvent(of: .value, with: { snapshot in
            let userData = snapshot.value as! [String: Any]
            completion(userData)
        })
    }
    
    func getUserDataFromTransfer(code: String, completion: @escaping ([String:Any]?) -> Void) {
        userDataRef.child(code).observeSingleEvent(of: .value, with: { snapshot in
            let userData = snapshot.value as? [String: Any]
            completion(userData)
        })
    }
    
    func updateHighScoreForLevel(_ num: Int, score: Int) {
//        highScoreDataRef.child("Level_\(num)").observeSingleEvent(of: .value, with: { snapshot in
//            if var highScores = snapshot.value as? [Int:String] {
//                var minScore = Int.max
//                for (newScore, user) in highScores {
//                    print(newScore)
//                    print(user)
//                    if newScore < minScore {
//                        minScore = newScore
//                    }
//                }
//                if score > minScore {
//                    highScores[score]
//                }
//            }
//            
//        })
        
    }
    
    func saveToDoc(levelData: [String: Any], level: Int){
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        //print(docs.absoluteString)
        let fileUrl = docs.appendingPathComponent("Level_\(level).json")
        do {
            let data = try JSONSerialization.data(withJSONObject: levelData, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
}
