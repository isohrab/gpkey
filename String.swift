//
//  String.swift
//  GPkey
//
//  Created by sohrab on 01/10/16.
//  Copyright © 2016 ark. All rights reserved.
//

import Foundation

extension String {
    
    public func charAt(_ i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self.charAt(i) as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        return substring(with: self.characters.index(self.startIndex, offsetBy: r.lowerBound)..<self.characters.index(self.startIndex, offsetBy: r.upperBound))
    }
    
    public subscript (r: CountableClosedRange<Int>) -> String {
        return substring(with: self.characters.index(self.startIndex, offsetBy: r.lowerBound)..<self.characters.index(self.startIndex, offsetBy: r.upperBound))
    }
    
    public func replaceCharAt(i: Int, c: String) -> String{
        var chars = Array(self.characters)
        print(c.characters.first!)
        chars[i] = c.characters.first!
        return String(chars)
    }
    
}
