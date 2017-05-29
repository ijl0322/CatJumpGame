//
//  AllLevels.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 28/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import Foundation
class AllLevels {
    static let shared = AllLevels()
    var numberOfLevels = 0
    func countAvailableLevels() {
        var i = 1
        while true {
            let filename = "Level_\(i)"
            let dictionary = Dictionary<String, AnyObject>.loadJSONFromDocument(filename: filename)
            if dictionary == nil || (dictionary?.isEmpty)! {
                print("\n\n\n\n\nAvailable levels \(numberOfLevels)")
                break
            } else {
                numberOfLevels = i
                i += 1
            }
        }
    }
}
