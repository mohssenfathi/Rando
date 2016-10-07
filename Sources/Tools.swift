//
//  Tools.swift
//  Rando
//
//  Created by Mohssen Fathi on 10/7/16.
//
//

#if os(Linux)
//    import GlibC
#else
    import Foundation
#endif

public
class Tools: NSObject {

    public class func random(between min: Float, and max: Float) -> Float {
        
        #if os(Linux)
            return Float(random() % (max + 1)) + min
        #else
            return Float(arc4random() / UInt32.max) * max + min
        #endif
    }
    
}
