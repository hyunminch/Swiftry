// MIT License
//
// Copyright (c) 2016 Hyun Min Choi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import XCTest
@testable import Swiftry

enum SwiftryError: Error {
    case someError
}

class SwiftryTests: XCTestCase {
    let f1: (Int) -> Int = { return 2 * $0 }
    let f2: (Int) -> Swiftry<Double> = { div in
        return Swiftry<Double> {
            if div == 0 {
                throw SwiftryError.someError
            } else {
                return 1.0 / Double(div)
            }
        }
    }
    
    let c1: (Int) throws -> Int = { n in
        var c = n
        var cnt = 0
        while (c > 1) {
            if c % 2 == 0 {
                c = c / 2
                cnt = cnt + 1
            } else {
                throw SwiftryError.someError
            }
        }
        return cnt
    }
    
    func testInit() {
        let tried = Swiftry(value: 3)
        XCTAssert(tried.get == 3)
        
        let t1 = Swiftry { [unowned self] _ in
            return try self.c1(128)
        }
        XCTAssert(t1.get == 7)
        
        let t2 = Swiftry<Int> { try self.c1(256) }
        XCTAssert(t2.get == 8)
        
        let t3 = Swiftry { try self.c1(255) }
        XCTAssert(t3.isErrored)
        
        let t4 = Swiftry({ try self.c1(255) })
        XCTAssert(t4.isErrored)
    }
    
    func testOrElse() {
        let t1 = Swiftry<Int>(value: 5)
        let t2 = Swiftry<Int>(error: SwiftryError.someError)
        let t3 = Swiftry<Int>(value: 6)
        
        let result1 = t1.orElse(t2).orElse(t3)
        XCTAssert(result1.isSuccessful)
        
        let result2 = t2.orElse(t2)
        XCTAssert(result2.isErrored)
    }
    
    func testMonadicMethods() {
        let t1 = Swiftry<Int>(value: 5)
        XCTAssert(t1.map(f1).get == 10)
        
        let t2 = Swiftry<Int>(value: 0)
        XCTAssert(t2.flatMap(f2).isErrored)
        
        let t3 = Swiftry<Int>(value: 128)
        XCTAssert(t3.flatMap(f2).isSuccessful)
    }
    
    func testOperators() {
        let t1 = Swiftry<Int>(value: 5)
        let t2 = Swiftry<Int>(error: SwiftryError.someError)
        let t3 = Swiftry<Int>(value: 6)
        let t4 = Swiftry<Int>(value: 0)
        
        let result1 = t1 => t2
        XCTAssert(result1.get == 5)
        
        let result2 = t2 => t3
        XCTAssert(result2.get == 6)
        
        let result3 = t1 => t2 => t3
        XCTAssert(result3.get == 5)
        
        XCTAssert((t1 <^> f1 <^> f1).get == 20)
        XCTAssert((t4 <^> f1 >>- f2).isErrored)
    }
    
    func testToOption() {
        let t1 = Swiftry<String>(value: "Abracadabra")
        let o1 = t1.toOption
        XCTAssert(o1 == "Abracadabra")
        
        let t2 = Swiftry<Double>(error: SwiftryError.someError)
        let o2 = t2.toOption
        XCTAssert(o2 == nil)
    }
}
