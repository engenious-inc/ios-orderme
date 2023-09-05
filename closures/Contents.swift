import UIKit

var closure: () -> () = {}

var square: (Int) -> Int = { x in
   return x * x
}

square(5)
