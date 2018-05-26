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

/// Represents an API route, usually being an enumeration.
protocol ApiRoutes {
    /// Path that will be appended to a base URL.
    var path: String { get }

    /// HTTP headers. Defaults to being empty.
    var headers: [String: String] { get }

    /// HTTP method. Defaults to `.get`.
    var method: HttpMethods { get }

    /// URL query parameters. Defaults to being empty.
    var parameters: [URLQueryItem] { get }

    /// HTTP body. Defaults `nil`.
    var body: Data? { get }

    /// If the route's return value conforms to `Decodable` the type can be specified here. This adds support for
    /// `API.requestDecoded`, which returns the server's response as a decoded object. Defaults to `nil`.
    var responseType: Decodable.Type? { get }

    /// Returns the full URL for this route.
    ///
    /// - Parameter baseUrl: Base URL to append route to.
    /// - Returns: Full URL for this route.
    func url(for baseUrl: URL) -> URL

    /// Returns a ready-to-use `URLRequest` to use for this route.
    ///
    /// - Parameter baseUrl: Base URL to append route to.
    /// - Returns: Request for this route.
    func request(for baseUrl: URL) -> URLRequest
}

// MARK: - Default Implementation

extension ApiRoutes {
    var headers: [String: String] {
        return [:]
    }

    var method: HttpMethods {
        return .get
    }

    var parameters: [URLQueryItem] {
        return []
    }

    var body: Data? {
        return nil
    }

    var responseType: Decodable.Type? {
        return nil
    }

    func url(for baseUrl: URL) -> URL {
        let url = baseUrl.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters
        return components?.url ?? url
    }

    func request(for baseUrl: URL) -> URLRequest {
        var request = URLRequest(url: url(for: baseUrl))
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
