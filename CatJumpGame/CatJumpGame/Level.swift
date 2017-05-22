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

class Level {
    fileprivate var breads = Array2D<Bread>(columns: NumColumns, rows: NumRows)
    fileprivate var tiles = Array2D<Int>(columns: NumColumns, rows: NumRows)
    
    init(filename: String) {
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename) else { return }
        
        guard let tilesArray = dictionary["tiles"] as? [[Int]] else { return }
        
        for (row, rowArray) in tilesArray.enumerated() {
            print(row, rowArray)
            let tileRow = NumRows - row - 1
            for (column, value) in rowArray.enumerated() {
                tiles[column, tileRow] = value
                print(column, tileRow)
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
                    }
                }
            }
        }
        return set
    }
}