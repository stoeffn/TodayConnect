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

extension Result {
    /// Creates a new result depending on whether the value given is `nil`.
    ///
    /// - Parameters:
    ///   - value: Optional value. Result will be a failure if set to `nil`.
    ///   - error: Optional error. Result will be a failure if set.
    ///   - statusCode: Optional HTTP status code. Result will be a failure if not in the 200 range.
    init(_ value: Value?, error: Error? = nil, statusCode: Int?) {
        if let value = value, let statusCode = statusCode, error == nil, 200 ... 299 ~= statusCode {
            self = .success(value)
            return
        }
        self = .failure(error)
    }
}

// MARK: - Default Implementation

extension Result where Value == Data {
    /// Returns the API result decoded from its JSON representation. If the data is not valid, the return value will be a
    /// `.failure`.
    ///
    /// - Parameter type: Expected object type.
    func decoded<Value: Decodable>(_ type: Value.Type) -> Result<Value> {
        return map { try JSONDecoder().decode(type, from: $0) }
    }
}
