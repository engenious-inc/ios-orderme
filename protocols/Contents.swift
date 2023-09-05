import UIKit

protocol Pet {
    var weight: Double { get }
    
    func eat()
    func greet()
}


class Dog: Pet {
    var weight: Double
    
    init(weight: Double) {
        self.weight = weight
    }
    
    func eat() {
        self.weight += 2
    }
    
    func greet() {
        print("BARK!")
    }
}

class Cat: Pet {
    var weight: Double
    
    init(weight: Double) {
        self.weight = weight
    }
    
    func eat() {
        weight += 1
    }
    
    func greet() {
        print("MEOW!")
    }
}
