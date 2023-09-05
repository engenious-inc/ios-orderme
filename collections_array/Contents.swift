import UIKit

// https://developer.apple.com/documentation/swift/array


var names: [String] = []

names = ["John", "Bob", "Richard"]

var isEmpty = names.isEmpty

names.count

print(names[names.count - 1])

//print(names[4])

names.append("Judy")

names += ["Judy"]

names.contains("Richard")
