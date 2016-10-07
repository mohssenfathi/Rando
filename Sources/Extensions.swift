//
//  Extensions.swift
//  Rando
//
//  Created by Mohssen Fathi on 10/5/16.
//
//

import Foundation

public
extension Array {

    func random() -> Iterator.Element {
        let i = Int(arc4random_uniform(UInt32(count)) + 1)
        return self[i]
    }
    
}
