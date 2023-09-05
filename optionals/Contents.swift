import UIKit

var optionalString: String? = "Hello, world!"

optionalString = nil

let namesAndAges = ["John": 25, "Mike": 35]

print(namesAndAges["John"])

print(namesAndAges["Abby"])

let age = namesAndAges["John"]

//let doubleAge = age * 2

let realAge = age!

print(realAge)

if let realAge = age {
    print(realAge)
}

func test () {
    let age: Int? = 10
    guard let realAge = age else {
        print("NIL is found")
        return
    }
    
    print(realAge)
}

test()
