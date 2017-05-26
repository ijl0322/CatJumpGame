//
//  Level.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 20/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import Foundation

let NumColumns = 8
let NumRows = 9

enum LevelCompleteType: Int, CustomStringConvertible {
    case lose = 0, oneStar, twoStar, threeStar
    
    init?(raw: Int) {
        self.init(rawValue: raw)
    }

    var description: String {
        let status = ["lose", "oneStar", "twoStar", "threeSrar"]
        
        return status[rawValue]
    }
    
    var coins: Int {
        let cointsReceived = [0, 1000, 1200, 1500]
        return cointsReceived[rawValue]
    }
}


class Level {
    fileprivate var breads = Array2D<Bread>(columns: NumColumns, rows: NumRows)
    fileprivate var tiles = Array2D<Int>(columns: NumColumns, rows: NumRows)
    
    var highestScore = 0
    var timeLimit = 0
    
    init(filename: String) {
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename) else { return }
        
        guard let tilesArray = dictionary["tiles"] as? [[Int]] else { return }
        guard let time = dictionary["timeLimit"] as? Int else {return}
        self.timeLimit = time
        
        for (row, rowArray) in tilesArray.enumerated() {
            let tileRow = NumRows - row - 1
            for (column, value) in rowArray.enumerated() {
                tiles[column, tileRow] = value
            }
        }
    }
    
    func breadAt(column: Int, row: Int) -> Bread? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return breads[column, row]
    }
    
    func loadBread() -> Set<Bread> {
        var set = Set<Bread>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if tiles[column, row] != 0{
                    let breadType = BreadType.init(raw: tiles[column, row]!)
                    if let breadType = breadType {
                        let bread = Bread(column: column, row: row, breadType: breadType)
                        breads[column, row] = bread
                        set.insert(bread)
                        highestScore += breadType.points
                    }
                }
            }
        }
        
        print("Hightest score for this level: \(highestScore)")
        return set
    }
    
    func levelCompleteStatus(score: Int) -> LevelCompleteType{
        if Double(score) >= Double(highestScore){
            return .threeStar
        } else if Double(score) >= Double(highestScore) * 0.9 {
            return .twoStar
        } else if Double(score) >= Double(highestScore) * 0.75 {
            return .oneStar
        } else {
            return .lose
        }
    }
}
