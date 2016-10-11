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
        let i = Int(Tools.rand(between: 0.0, and: Float(count + 1)))
        return self[i]
    }
    
}
