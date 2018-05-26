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

/// Wrapper around `URLSession` that allows simple and easy access to an API.
///
/// To use it, just create your own type, peferably an enumeration, implementing `ApiRoutes` and initialize an instance of this
/// class with your routes and a base `URL`.
///
/// You can use this class to make API requests, decode them automatically, and download files.
///
/// Depending on the `URLSession` given on initialization, this class uses the default `URLCredentialStorage`.
///
/// - Remark: This class is not marked `final` in order to allow subclassing for mock implementations. Usually, you will not
///           need to subclass it.
class Api<Routes: ApiRoutes> {

    // MARK: - Life Cycle

    private let session: URLSession

    /// Base `URL` of all requests this instance issues. Any route paths will be appended to it.
    let baseUrl: URL

    /// Creates a new API wrapper at `baseUrl`.
    ///
    /// - Parameters:
    ///   - baseUrl: Base `URL` of all requests this instance issues. Any route paths will be appended to it.
    ///   - session: URL Session, which defaults to the shared session.
    init(baseUrl: URL, session: URLSession = .shared) {
        self.baseUrl = baseUrl
        self.session = session
    }

    // MARK: - Creating Requests

    // MARK: - Making Data Requests

    /// Requests data from this API.
    ///
    /// - Parameters:
    ///   - route: Route to request data from.
    ///   - completion: Completion handler receiving a result with the received response and data or an error.
    /// - Returns: URL task in its resumed state or `nil` if building the request failed.
    @discardableResult
    func request(_ route: Routes, completion: @escaping ResultHandler<(Data, HTTPURLResponse)>) -> URLSessionTask {
        let task = session.dataTask(with: route.request(for: baseUrl)) { data, response, error in
            let result = Result(data: data, response: response as? HTTPURLResponse, error: error)
            completion(result)
        }
        task.resume()
        return task
    }

    /// Requests data from this API and decodes as the type defined by the route.
    ///
    /// - Parameters:
    ///   - route: Route to request data from.
    ///   - completion: Completion handler receiving a result with the response and decoded object or an error.
    /// - Returns: URL task in its resumed state or `nil` if building the request failed.
    /// - Precondition: `route`'s type must not be `nil`.
    /// - Remark: At the moment, this method supports JSON decoding only.
    @discardableResult
    func request<Result: Decodable>(_ route: Routes,
                                    completion: @escaping ResultHandler<(Result, HTTPURLResponse)>) -> URLSessionTask {
        guard let type = route.responseType as? Result.Type else {
            fatalError("Trying to decode response from untyped API route '\(route)'.")
        }
        return request(route) { result in
            completion(result.decoded(type))
        }
    }
}
