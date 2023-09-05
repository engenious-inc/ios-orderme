import UIKit

var namesAndAges: [String: Int] = [:]
namesAndAges = ["John": 25, "Abby": 21]

let age = namesAndAges["John"]

namesAndAges["John"]! += 1
print(namesAndAges)

let allKeys = [String](namesAndAges.keys)
let allValues = [Int](namesAndAges.values)
