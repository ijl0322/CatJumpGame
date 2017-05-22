//
//  Bread.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 20/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

class Bread: CustomStringConvertible, Hashable{
    var column: Int
    var row: Int
    let breadType: BreadType
    var sprite: BreadNode?
    var hashValue: Int {
        return row*10 + column
    }
    
    init(column: Int, row: Int, breadType: BreadType) {
        self.column = column
        self.row = row
        self.breadType = breadType
    }
    
    static func ==(lhs: Bread, rhs: Bread) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
    
    var description: String {
        return "type:\(breadType) square:(\(column),\(row))"
    }
}
