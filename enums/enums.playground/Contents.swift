import UIKit

enum CompassDirection {
    case north
    case south
    case east
    case west
}

var direction: CompassDirection = .north

enum MediaType {
    case book(title: String, author: String)
    case movie((title: String, director: String))
}

let favoriteBook = MediaType.book(title: "1985", author: "George Orwell")

switch favoriteBook {
case .book(let title, let author):
    print("Book: \(title) by \(author)")
case .movie((let title, let director)):
    print("Movie: \(title), directed by \(director)")
}

enum Planet: Int {
    case mercury = 1
    case venus
    case earth
    case mars
}

let earth = Planet.earth
print(earth.rawValue) // prints "3"

if let somePlanet = Planet(rawValue: 2) {
    print(somePlanet) // prints "venus"
}
