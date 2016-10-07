//
//  RandomGenerator.swift
//  Rando
//
//  Created by Mohssen Fathi on 10/4/16.
//
//

/*
    Useful links:
    https://en.wikipedia.org/wiki/Demography_of_the_United_States#Ages
    http://www.censusscope.org/us/chart_age.html
 */

import Foundation

let basePath = "/Users/mohssenfathi/Documents/RandoResources/"
let sourcePath = "./Sources/"

public
class RandomGenerator: NSObject {

    public static let sharedGenerator = RandomGenerator()
    
    var maleFirstNames: [Name]!
    var femaleFirstNames: [Name]!
    var allFirstNames: [Name]!
    var lastNames: [Name]!
    
    /*
        Age distribution provided by: http://www.censusscope.org/us/chart_age.html
        Given in increments of 4 years, ex. 0-4, 5-9, 10-14 ...
     */
    let ageDistributionFemale = [0.0333, 0.0356, 0.0356, 0.0349, 0.0330, 0.0341, 0.0362, 0.0405, 0.0402, 0.0363, 0.0319, 0.0247, 0.0201, 0.0182, 0.0176, 0.0155, 0.0111, 0.0107]
    let ageDistributionMale   = [0.0349, 0.0374, 0.0374, 0.0369, 0.0344, 0.0348, 0.0367, 0.0402, 0.0395, 0.0351, 0.0306, 0.0231, 0.0183, 0.0156, 0.0139, 0.0108, 0.0065, 0.0044]
    var ageDistributionTotal: [Double]!
    
    override init() {
        super.init()
        setup()
    }
    
    func setup() {
        
//        saveNames()
        loadNames()
        
        // Age Distribution
        ageDistributionTotal = [Double]()
        for i in 0 ..< ageDistributionMale.count {
            ageDistributionTotal.append(ageDistributionMale[i] + ageDistributionFemale[i])
        }
        
    }
    
    func loadNames() {
        maleFirstNames = readNames(file: "maleFirstNames")
        femaleFirstNames = readNames(file: "femaleFirstNames")
        allFirstNames = maleFirstNames + femaleFirstNames
        lastNames = readNames(file: "surnames")
    }
 
    
    
}


// Person Generation
extension RandomGenerator {
    
    public func randomPerson() -> Person {
        
        let firstName = allFirstNames.random()
        let lastName = lastNames.random()
        
        let person = Person(firstName: firstName.name.capitalized, lastName: lastName.name.capitalized)
        person.gender = firstName.gender
        
        // Set middle name. Maybe
        let i = Tools.random(between: 0.0, and: 1.0)
        if i > 0.5 {
            person.middleName = allFirstNames.random().name.capitalized
        } else if i > 0.75 {
            person.middleName = lastNames.random().name.capitalized
        }
        
        let age = randomAge(gender: person.gender)
        let seconds = -age * 365.0 * 24.0 * 3600.0
        person.birthday = Date(timeIntervalSinceNow: seconds)
        
        return person
    }
    
    func randomAge(gender: Gender) -> Double {
        
        var distribution: [Double]!
        if gender == .male {
            distribution = ageDistributionMale
        } else if gender == .female {
            distribution = ageDistributionFemale
        } else {
            distribution = ageDistributionTotal
        }
        
        let age = Double(randomNumber(distribution: distribution)) * 4.0
        let increment = Double(Tools.random(between: 0.0, and: 1.0))
        
        return age + increment
    }
    
    func randomNumber(distribution: [Double]) -> Int {
        
        let sum = distribution.reduce(0, +)
        let rnd = sum * Double(Tools.random(between: 0.0, and: 1.0))
        
        var accum = 0.0
        for (i, p) in distribution.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        
        return (distribution.count - 1)
    }
}



// Parsing
extension RandomGenerator {

    func saveNames() {
        
        var names = parseNames(file: basePath + "male.txt", gender: .male, nameType: .first)
        _ = NSKeyedArchiver.archiveRootObject(names, toFile: basePath + "maleFirstNames")
        
        names = parseNames(file: basePath + "female.txt", gender: .female, nameType: .first)
        _ = NSKeyedArchiver.archiveRootObject(names, toFile: basePath + "femaleFirstNames")
        
        names = parseNames(file: basePath + "surnames.txt", gender: .neither, nameType: .last)
        _ = NSKeyedArchiver.archiveRootObject(names, toFile: basePath + "surnames")
    }
    
    func readNames(file: String) -> [Name] {
        
        var filename = sourcePath + file
        if let path = Bundle.main.path(forResource: file, ofType: nil) {
            filename = path
        }
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: filename) as! [Name]
    }
    
    func parseNames(file: String, gender: Gender, nameType: NameType) -> [Name] {

        let path = URL(fileURLWithPath: file)
        
        guard let contents = try? String(contentsOf: path, encoding: String.Encoding.utf8) else {
            return []
        }
        
        var names = [Name]()
        let lines = contents.components(separatedBy: "\n")
        for line in lines {
            let items = line.components(separatedBy: .whitespaces)
            if let name = items.first {
                if name != "" {
                    let n = Name(name: name.lowercased(), type: nameType, gender: gender)
                    names.append(n)
                }
            }
        }
        
        return names
    }
    
}

