//
//  Person.swift
//  Rando
//
//  Created by Mohssen Fathi on 10/4/16.
//
//

import Foundation
import SwiftyJSON

public
enum Gender: Int {
    case male = 0
    case female
    case neither
    case unknown
    
    func stringValue() -> String {
        switch self {
        case .male   : return "Male"
        case .female : return "Female"
        case .neither: return "Neither"
        case .unknown: return "Unknown"
        }
    }
}

public
class Person: NSObject {

    public init(firstName: String, lastName: String) {
        super.init()
        
        self.firstName = firstName
        self.lastName = lastName
    }
    
    
    // MARK: - Name
    public var firstName: String!
    public var middleName: String?
    public var lastName: String!
    public var fullName: String {
        
        if let middleName = middleName {
            return firstName + " " + middleName + " " + lastName
        }
        return firstName + " " + lastName
    }
    
    
    // MARK: - Gender
    public var gender: Gender = .unknown
    
    
    // MARK: - Age
    public var age: Double {
        
        // Use NSCalendar later. Not adjusting for leap year, DST, anything...
        let seconds = birthday.timeIntervalSinceNow
        return seconds / 365.0 / 24.0 / 3600.0
    }
    
    func ageComponents() -> DateComponents {
        return NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: birthday, to: Date())
    }
    
    func formattedAge() -> String {

        let components: DateComponents = ageComponents()
        
        let years = components.year ?? 0
        let months = components.month ?? 0
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        return "\(years) years, \(months) months, \(days) days, \(hours)h : \(minutes)m : \(seconds)s"
    }
    
    // MARK: - Birthday
    public var birthday: Date = Date()
    
    func birthdayComponents() -> DateComponents {
        return NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: birthday)
    }
    
    func formattedBirthday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, YYYY"
        return formatter.string(from: birthday as Date)
    }

    
    var info: [String : Any]? {
        
        let ageComponents = self.ageComponents()
        let birthdayComponents = self.birthdayComponents()
        
        let i: [String : Any] = [
            
            "firstName"  : firstName,
            "middleName" : middleName ?? "",
            "lastName"   : lastName,
            "fullName"   : fullName,
            "gender"     : gender.stringValue(),
            
            "age" : [
                "years"     : ageComponents.year!,
                "months"    : ageComponents.month!,
                "days"      : ageComponents.day!,
                "hours"     : ageComponents.hour!,
                "minutes"   : ageComponents.minute!,
                "seconds"   : ageComponents.second!,
                "formatted" : formattedAge(),
            ],
            
            "birthday" : [
                "year"     : birthdayComponents.year!,
                "month"    : birthdayComponents.month!,
                "day"      : birthdayComponents.day!,
                "formatted" : formattedBirthday(),
            ]
        ]
        
        if !JSONSerialization.isValidJSONObject(i) {
            return nil
        }
        
        return i
    }

    var json: JSON? {
        guard let info = info else { return nil }
        guard let data = try? JSONSerialization.data(withJSONObject: info, options: .prettyPrinted) else {
            return nil
        }
        return JSON(data: data)
    }
    
}



