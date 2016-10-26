# Swiftry
Swiftry is Scala's Try brought to Swift. 

## Usage
Initialization
```swift
let a = 3
let x = Swiftry {
  if a % 2 == 0 {
    return a / 2
  } else {
    throw MyError.error
  }
}
let y = Swiftry { 5 }
let z = Swiftry<String>("abracadabra")
let e = Swiftry(error: MyError.error)
```

Pattern Matching
```swift
let x = Swiftry { ... }
switch x {
case let .success(s):
  ...
case let .failure(e):
  ...
}
```

`=>` (orElse) Operator
```swift
let x = 15
let y = 5
let z = 0

// both equal Swiftry.success(3)
Swiftry {
  if z == 0 {
    throw MyError.error
  } else {
    return y / z
  }
} => Swiftry {
  x / y
}

Swiftry {
  if z == 0 {
    throw MyError.error
  } else {
    return y / z
  }
}.orElse(Swiftry {
  x / y
})
```

`>>-` (flatMap) Operator
```swift
let divideTwo: (Int) -> Swiftry<Int> = { x in
  Swiftry {
    if x % 2 == 0 {
      return x / 2
    } else {
      throw MyError.error
    }
  }
}

// both equal Swiftry.success(1)
let swiftryOneOp = Swiftry(8) >>- divideTwo >>- divideTwo >>- divideTwo
let swiftryOneCall = Swiftry(8).flatMap(divideTwo).flatMap(divideTwo).flatMap(divideTwo)
// both equal Swiftry.failure(MyError.myerror)
let swiftryFailureOp = swiftryOneOp >>- divideTwo
let swiftryFailureCall = swiftryOneCall.flatMap(divideTwo)
```

`<^>` (map) operator
```swift
let f: (Int) -> Int = { return 2 * $0 }
// both equal Swiftry.success(10)
let tOp = Swiftry(5) <^> f
let tCall = Swiftry(5).map(f)
```

## Installation

#### [CocoaPods](https://cocoapods.org)
Add the following line to your Podfile.
```ruby
pod 'Swiftry', '~> 0.1.3'
```

#### [Carthage](https://github.com/Carthage/Carthage)
Add the following line to your Cartfile.
```
github "nitrogenice/Swiftry" ~> 0.1.3
```

## License

**Swiftry** is under an MIT license. See the [LICENSE](LICENSE) file for more information.