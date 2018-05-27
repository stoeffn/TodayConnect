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

enum AuthorizationApiRoutes: ApiRoutes {
    case logIn(accountName: String, password: String)

    case verify(sessionId: String, scnt: String, securityCode: String)

    case trustClient(sessionId: String, scnt: String)

    var path: String {
        switch self {
        case .logIn:
            return "auth/signin"
        case .verify:
            return "auth/verify/trusteddevice/securitycode"
        case .trustClient:
            return "auth/2sv/trust"
        }
    }

    var method: HttpMethods {
        switch self {
        case .logIn, .verify:
            return .post
        case .trustClient:
            return .get
        }
    }

    var headers: [String: String] {
        switch self {
        case .logIn:
            return [:]
        case let .verify(sessionId, scnt, _),
             let .trustClient(sessionId, scnt):
            return [
                "X-Apple-Id-Session-Id": sessionId,
                "scnt": scnt,
            ]
        }
    }

    var body: Data? {
        switch self {
        case let .logIn(accountName, password):
            return encoded(LoginRequest(accountName: accountName, password: password))
        case let .verify(_, _, securityCode):
            return encoded(VerifySecurityCodeRequest(securityCode: VerifySecurityCodeRequest.SecurityCode(code: securityCode)))
        case .trustClient:
            return nil
        }
    }

    private func encoded<Request: Encodable>(_ request: Request) -> Data? {
        return try? JSONEncoder().encode(request)
    }
}
