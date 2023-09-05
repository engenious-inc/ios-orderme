import UIKit

class Car {
    var model: String
    private var speed: Int
    var color: String

    init(model: String, speed: Int, color: String) {
        self.model = model
        self.speed = speed
        self.color = color
    }

    func repaint(newColor: String) {
        color = newColor
    }

    func accelerate(deltaSpeed: Int) {
        speed += deltaSpeed
    }
}

let mercedes = Car(model: "S63", speed: 0, color: "black")
let bmw = Car(model: "M4", speed: 30, color: "white")

print(mercedes.color)
bmw.accelerate(deltaSpeed: 30)

//print(mercedes.speed)
