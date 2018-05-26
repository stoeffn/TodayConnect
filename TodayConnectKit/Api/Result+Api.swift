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

extension Result where Value == (Data, HTTPURLResponse) {
    /// Creates a new result based on the result of an HTTP request with its response, data, and error.
    init(data: Data?, response: HTTPURLResponse?, error: Error?) {
        if error == nil, let response = response, let data = data, 200 ... 299 ~= response.statusCode {
            self = .success((data, response))
            return
        }
        self = .failure(error)
    }

    /// Returns the API result decoded from its JSON representation. If the data is not valid, the return value will be a
    /// `.failure`.
    ///
    /// - Parameter type: Expected object type.
    func decoded<Value: Decodable>(_ type: Value.Type) -> Result<(Value, HTTPURLResponse)> {
        return map { (try JSONDecoder().decode(type, from: $0.0), $0.1) }
    }
}
