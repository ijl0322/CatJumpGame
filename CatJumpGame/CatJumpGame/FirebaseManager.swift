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
    
    func test() {
        print("posting")
        let data: [String: Any] = ["tiles" : [ [12, 12, 13, 13, 13, 13, 12, 12],
        [11, 11, 11, 11, 11, 11, 11, 11],
        [8, 8, 8, 9, 9, 8, 8, 8],
        [7, 7, 7, 7, 7, 7, 7, 7],
        [2, 2, 2, 4, 4, 2, 2, 2],
        [6, 6, 6, 6, 6, 6, 6, 6],
        [5, 5, 5, 3, 3, 5, 5, 5],
        [1, 0, 0, 0, 0, 0, 0, 1],
        [0, 0, 0, 0, 0, 0, 0, 0] ], "timeLimit": 50]
        levelsRef.child("1").setValue(data)
    }
    
    func loadLevel(num: Int, completion: @escaping (([String:Any]) -> Void)) {
        levelsRef.child("\(num)").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot)
            let level = snapshot.value as! [String: Any]
            completion(level)
            self.saveToDoc(levelData: level)
            
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
    
    func getUserDataFromTransfer(code: String, completion: @escaping ([String:Any]) -> Void) {
        userDataRef.child(code).observeSingleEvent(of: .value, with: { snapshot in
            let userData = snapshot.value as! [String: Any]
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
    
    func saveToDoc(levelData: [String: Any]){
        let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("\(docs)")
        NSKeyedArchiver.archiveRootObject(levelData, toFile: docs.appending("/Level_1.plist"))
    }
    
    func download() {
        levelsRef.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot)
            let levels = snapshot.value as! [Any]
            let dictionary = levels[1] as! [String: Any]
            
        })
    }
}
