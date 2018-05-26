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

public final class ConnectApi {
    public enum Errors: Error {
        case noAppConfig
    }

    private let session = URLSession.shared
    private let appConfigUrl = URL(string: "https://olympus.itunes.apple.com/v1/app/config/")!
    private let host = "itunesconnect.apple.com"

    private var appConfig: AppConfigResponse?
    private var sessionId: String?
    private var scnt: String?

    public init() {}

    private func httpHeaderFields(for appConfig: AppConfigResponse) -> [String: String] {
        return [
            "Accept": "application/json, text/javascript",
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "X-Apple-Widget-Key": appConfig.authServiceKey,
            "X-Apple-ID-Session-Id": sessionId ?? "",
            "scnt": scnt ?? ""
        ]
    }

    private func appConfiguration(forHost host: String, completion: @escaping ResultHandler<AppConfigResponse>) {
        guard let url = URL(string: appConfigUrl.absoluteString + "?hostname=\(host)") else { fatalError() }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request) { data, response, error in
            let result = Result(data: data, response: response as? HTTPURLResponse, error: error)
            completion(result.decoded(AppConfigResponse.self).map { $0.0 })
        }
        task.resume()
    }

    public func refreshConfiguration(completion: @escaping ResultHandler<Void>) {
        appConfiguration(forHost: host) { result in
            self.appConfig = result.value ?? self.appConfig
            completion(result.map { _ in })
        }
    }

    public func login(email: String, password: String, completion: @escaping ResultHandler<Void>) {
        guard let appConfig = self.appConfig else {
            return completion(.failure(Errors.noAppConfig))
        }

        let url = appConfig.authServiceUrl.appendingPathComponent("auth/signin")
        let loginRequest = LoginRequest(accountName: email, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaderFields(for: appConfig)
        request.httpBody = try? JSONEncoder().encode(loginRequest)

        let task = session.dataTask(with: request) { data, response, error in
            let result = Result(data: data, response: response as? HTTPURLResponse, error: error)
            // self.sessionId = response?.allHeaderFields["X-Apple-ID-Session-Id"] as? String
            // self.scnt = response?.allHeaderFields["scnt"] as? String
            completion(result.map { _ in })
        }
        task.resume()
    }

    public func verifyDevice(securityCode: String, completion: @escaping ResultHandler<Void>) {
        guard let appConfig = self.appConfig else {
            return completion(.failure(Errors.noAppConfig))
        }

        let url = appConfig.authServiceUrl.appendingPathComponent("auth/verify/trusteddevice/securitycode")
        let verifyDeviceRequest = VerifySecurityCodeRequest(securityCode: VerifySecurityCodeRequest.SecurityCode(code: securityCode))
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaderFields(for: appConfig)
        request.httpBody = try? JSONEncoder().encode(verifyDeviceRequest)

        let task = session.dataTask(with: request) { data, response, error in
            let result = Result(data: data, response: response as? HTTPURLResponse, error: error)
            completion(result.map { _ in })
        }
        task.resume()
    }

    public func trust(completion: @escaping ResultHandler<Void>) {
        guard let appConfig = self.appConfig else {
            return completion(.failure(Errors.noAppConfig))
        }

        let url = appConfig.authServiceUrl.appendingPathComponent("auth/2sv/trust")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = httpHeaderFields(for: appConfig)

        let task = session.dataTask(with: request) { data, response, error in
            let result = Result(data: data, response: response as? HTTPURLResponse, error: error)
            completion(result.map { _ in })
        }
        task.resume()
    }

    public func test(completion: @escaping ResultHandler<Void>) {
        guard let appConfig = self.appConfig else {
            return completion(.failure(Errors.noAppConfig))
        }

        let url = URL(string: "https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/apps/1317593772/platforms/ios/reviews/summary?storefront=DE")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = httpHeaderFields(for: appConfig)

        let task = session.dataTask(with: request) { data, response, error in
            let result = Result(data: data, response: response as? HTTPURLResponse, error: error)
            completion(result.map { _ in })
        }
        task.resume()
    }
}
