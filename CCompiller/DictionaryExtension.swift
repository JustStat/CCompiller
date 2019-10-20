//
//  DictionaryExtension.swift
//  CCompiller
//
//  Created by Kirill Varlamov on 18/10/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import Foundation

extension Character: Strideable {
    public func distance(to other: Character) -> Int {
        return abs(Int(self.asciiValue! - other.asciiValue!))
    }
    
    public func advanced(by n: Int) -> Character {
        return Character(UnicodeScalar(asciiValue! + UInt8(n)))
    }
    
    public typealias Stride = Int
}

extension Character {
    func intValue() -> Int? {
        return (asciiValue != nil) ? Int(asciiValue!) : nil
    }
}
