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

import Foundation

public enum Swiftry<T> {
    case success(T)
    case failure(Error)
    
    public init(_ closure: () throws -> T) {
        do {
            self = .success(try closure())
        } catch let e {
            self = .failure(e)
        }
    }
    
    public init(value: T) {
        self = .success(value)
    }
    
    public init(error: Error) {
        self = .failure(error)
    }
    
    public func map<U>(_ f: @escaping (T) -> U) -> Swiftry<U> {
        let sugar: (T) throws -> U = f
        return self.map(sugar)
    }
    
    public func map<U>(_ f: @escaping (T) throws -> U) -> Swiftry<U> {
        switch self {
        case let .success(t):
            do {
                return .success(try f(t))
            } catch let e {
                return .failure(e)
            }
        case let .failure(e):
            return .failure(e)
        }
    }
    
    public func flatMap<U>(_ f: @escaping (T) -> Swiftry<U>) -> Swiftry<U> {
        let sugar: (T) throws -> Swiftry<U> = f
        return self.flatMap(sugar)
    }
    
    public func flatMap<U>(_ f: @escaping (T) throws -> Swiftry<U>) -> Swiftry<U> {
        switch self {
        case let .success(t):
            do {
                return try f(t)
            } catch let e {
                return .failure(e)
            }
        case let .failure(e):
            return .failure(e)
        }
    }
    
    public var asOptional: Optional<T> {
        switch self {
        case let .success(t):
            return t
        case .failure(_):
            return nil
        }
    }
    
    public func orElse(_ rightTry: @autoclosure () -> Swiftry<T>) -> Swiftry<T> {
        switch self {
        case .success(_):
            return self
        case .failure(_):
            return rightTry()
        }
    }
    
    public var get: T {
        return try! _get()
    }
    
    public var isSuccessful: Bool {
        switch self {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    public var isErrored: Bool {
        return !self.isSuccessful
    }
    
    internal func _get() throws -> T {
        switch self {
        case let .success(t):
            return t
        case let .failure(e):
            throw e
        }
    }
}

infix operator <->: AdditionPrecedence

public func <-><T>(lhs: Swiftry<T>, rhs: @autoclosure () -> Swiftry<T>) -> Swiftry<T> {
    return lhs.orElse(rhs)
}

infix operator <^>: AdditionPrecedence

public func <^><T, U>(lhs: Swiftry<T>, f: @escaping (T) -> U) -> Swiftry<U> {
    return lhs.map(f)
}

public func <^><T, U>(lhs: Swiftry<T>, f: @escaping (T) throws -> U) -> Swiftry<U> {
    return lhs.map(f)
}

infix operator >>-: AdditionPrecedence

public func >>-<T, U>(lhs: Swiftry<T>, f: @escaping (T) -> Swiftry<U>) -> Swiftry<U> {
    return lhs.flatMap(f)
}

public func >>-<T, U>(lhs: Swiftry<T>, f: @escaping (T) throws -> Swiftry<U>) -> Swiftry<U> {
    return lhs.flatMap(f)
}
