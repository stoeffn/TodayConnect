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

final class AuthorizationApi {
    private let api: Api<AuthorizationApiRoutes>
    private var sessionId: String?
    private var scnt: String?

    // MARK: - Life Cycle

    init(api: Api<AuthorizationApiRoutes>) {
        self.api = api
    }

    convenience init(appConfig: AppConfigResponse) {
        let session = URLSession(configuration: AuthorizationApi.sessionConfig(for: appConfig))
        self.init(api: Api<AuthorizationApiRoutes>(baseUrl: appConfig.authServiceUrl, session: session))
    }

    // MARK: - Configuring

    private static func sessionConfig(for appConfig: AppConfigResponse) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Accept": "application/json, text/javascript",
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "X-Apple-Widget-Key": appConfig.authServiceKey
        ]
        return configuration
    }

    // MARK: - Logging In

    @discardableResult
    func logIn(email: String, password: String, completion: @escaping ResultHandler<Void>) -> URLSessionTask {
        return api.request(.logIn(accountName: email, password: password)) { result in
            self.sessionId = result.value?.response.allHeaderFields["X-Apple-ID-Session-Id"] as? String
            self.scnt = result.value?.response.allHeaderFields["scnt"] as? String

            switch result.value?.response.statusCode {
            case 200:
                return completion(.success(()))
            case 403:
                return completion(.failure(Errors.invalidCredentials))
            case 409:
                return completion(.failure(Errors.requiresSecurityCode))
            default:
                return completion(.failure(Errors.notImplemented))
            }
        }
    }

    @discardableResult
    func verifySecurityCode(code: String, completion: @escaping ResultHandler<Void>) -> URLSessionTask? {
        guard let sessionId = sessionId, let scnt = scnt else {
            completion(.failure(Errors.notLoggedIn))
            return nil
        }

        return api.request(.verify(sessionId: sessionId, scnt: scnt, securityCode: code)) { result in
            switch result.value?.response.statusCode {
            case 200:
                return completion(.success(()))
            case 401, 403:
                return completion(.failure(Errors.invalidSecurityCode))
            default:
                return completion(.failure(Errors.notImplemented))
            }
        }
    }

    @discardableResult
    func trust(completion: @escaping ResultHandler<Void>) -> URLSessionTask? {
        guard let sessionId = sessionId, let scnt = scnt else {
            completion(.failure(Errors.notLoggedIn))
            return nil
        }

        return api.request(.trustClient(sessionId: sessionId, scnt: scnt)) { result in
            completion(result.map { _ in })
        }
    }
}

// MARK: - Errors

extension AuthorizationApi {
    enum Errors: Error {
        case invalidCredentials, notImplemented, requiresSecurityCode, notLoggedIn, invalidSecurityCode
    }
}
