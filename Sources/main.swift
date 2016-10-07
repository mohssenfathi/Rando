
import Kitura
import HeliumLogger

HeliumLogger.use()

let router = Router()

router.get("/") {
    request, response, next in
    response.send("Hello, World!")
    next()
}

router.get("/person") {
    request, response, next in
    
    let person = RandomGenerator.sharedGenerator.randomPerson()
    
    guard let json = person.json else {
        response.send("Error loading random person")
        next()
        return
    }
    
    response.send(json: json)
    
    next()
}

Kitura.addHTTPServer(onPort: 8181, with: router)
Kitura.run()
