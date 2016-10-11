//
//  Tools.swift
//  Rando
//
//  Created by Mohssen Fathi on 10/7/16.
//
//

#if os(Linux)
    import Glibc
#endif

import Foundation

public
class Tools: NSObject {

    public class func rand(between min: Float, and max: Float) -> Float {
        
        #if os(Linux)
            return Float(random() % Int(max) + 1) + min
        #else
            return Float(arc4random()) / Float(UInt32.max) * max + min
        #endif
    }
    
}
