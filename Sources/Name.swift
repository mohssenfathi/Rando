//
//  Name.swift
//  Rando
//
//  Created by Mohssen Fathi on 10/5/16.
//
//

import Foundation

public
enum NameType: Int {
    case first
    case middle
    case last
    case full
    case unknown
}

public
class Name: NSObject {

    public var name: String!
    public var type: NameType = .unknown
    public var gender: Gender = .unknown
    
    public init(name: String, type: NameType = .unknown, gender: Gender = .unknown) {
        self.name = name
        self.type = type
        self.gender = gender
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        
        name = aDecoder.decodeObject(forKey: "name") as! String!
        type = NameType(rawValue: aDecoder.decodeInteger(forKey: "type")) ?? .unknown
        gender = Gender(rawValue: aDecoder.decodeInteger(forKey: "gender")) ?? .unknown
    }
    
}

extension Name: NSCoding {
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(type.rawValue, forKey: "type")
        aCoder.encode(gender.rawValue, forKey: "gender")
    }

}
