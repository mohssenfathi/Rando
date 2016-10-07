//
//  Extensions.swift
//  Rando
//
//  Created by Mohssen Fathi on 10/5/16.
//
//

import Foundation

public
extension MutableCollection where Indices.Iterator.Element == Index {
    
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }

}

public
extension Array {

    func random() -> Iterator.Element {
        let i = Int(arc4random_uniform(UInt32(count)) + 1)
        return self[i]
    }
    
}

public
extension Sequence {
    
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
    
}
