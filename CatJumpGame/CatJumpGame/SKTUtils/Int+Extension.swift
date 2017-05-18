//
//  Int+Extension.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 18/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//


import CoreGraphics
public extension Int {
    /**
     * Converts an angle in degrees to radians.
     */
    public func toRadians() -> CGFloat{
        return π * CGFloat(self) / 180.0
    }
    
 
}
