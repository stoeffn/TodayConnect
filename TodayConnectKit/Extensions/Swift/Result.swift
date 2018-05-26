//
//  TodayConnect
//
//  Copyright © 2018 Steffen Ryll
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
//  modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
//  Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

/// Closure, usually a completion handler, that receives a result of the desired type or an error.
public typealias ResultHandler<Value> = (Result<Value>) -> Void

/// Container for either a value or an optional error.
///
/// Use this enumeration as a return or completion handler value instead of using a tuple consisting of both a value and an
/// error.
///
/// - success: Implies that an operation succeeded with a return value.
/// - failure: Implies that an operation failed with an optional error.
public enum Result<Value> {
    case failure(Error?)
    case success(Value)

    /// Creates a new result depending on whether the value given is `nil`.
    ///
    /// - Parameters:
    ///   - value: Optional value. Result will be a failure if set to `nil`.
    ///   - error: Optional error. Result will be a failure if set.
    init(_ value: Value?, error: Error? = nil) {
        if let value = value, error == nil {
            self = .success(value)
            return
        }
        self = .failure(error)
    }

    /// Returns whether self is `success`.
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }

    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }

    /// Returns the associated error if attached, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success: return nil
        case let .failure(error): return error
        }
    }

    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case let .success(value): return value
        case .failure: return nil
        }
    }

    /// Applies a transform to a result value if it is a `success`.
    ///
    /// - Parameter transform: Transform to apply to `value`.
    /// - Returns: `.failure` if this result is a failure or `transform` throws. Otherwise, a result with the transformed value
    ///            is returned.
    func map<NewValue>(_ transform: (Value) throws -> NewValue) -> Result<NewValue> {
        switch self {
        case let .success(value):
            do {
                return .success(try transform(value))
            } catch {
                return .failure(error)
            }
        case let .failure(error):
            return .failure(error)
        }
    }

    /// Applies a transform to a result value if it is a `success`.
    ///
    /// - Parameter transform: Transform to apply to `value`.
    /// - Returns: `.failure` if this result is a failure, `transform` throws, or `transform` returns `nil`. Otherwise, a result
    ///            with the transformed value is returned.
    func compactMap<NewValue>(_ transform: (Value) throws -> NewValue?) -> Result<NewValue> {
        switch self {
        case let .success(value):
            do {
                return Result<NewValue>(try transform(value))
            } catch {
                return .failure(error)
            }
        case let .failure(error):
            return .failure(error)
        }
    }
}
