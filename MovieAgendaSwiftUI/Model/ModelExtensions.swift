//
//  Extensions.swift
//  TesteMDBJSon
//
//  Created by Ricardo Venieris on 29/01/18.
//  Copyright © 2018 LES.PUC-RIO. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var wrapped:String {
        return self ?? ""
    }
}



/// Extension on Options with constraint to collection type
extension Optional where Wrapped: Collection {
    var hasElements:Bool {
        guard let value = self else { return false }
        return value.isEmpty
    }
}

extension Array where Element: Numeric {
    func sum() -> Element {
        return reduce(0, +)
    }
}

extension Int {
    mutating func limit(lower:Int = .min, upper:Int = .max) -> Int {
        self = self < lower ? lower : self > upper ? upper : self
        return self
    }
    
    var nextInt:Int {self+1}
}

extension Array where Element == String {
    var concat:Element {
        var result = reduce(""){val, element in "\(val), \(element)"}
        result.remove(at: result.startIndex)
        return result
    }
}

extension String {
    func addPath(_ itens:String...) -> String {
        var newString = self
        for item in itens {
            newString.append("/\(item)")
        }
        return newString
    }
}
