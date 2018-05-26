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

public final class AuthorizationCookieStorage: HTTPCookieStorage {
    private let defaults = UserDefaults(suiteName: App.groupIdentifier)
    private let cookiesKey = "cookies"

    public override func getCookiesFor(_ task: URLSessionTask, completionHandler: @escaping ([HTTPCookie]?) -> Void) {
        guard let cookiesProperties = defaults?.array(forKey: cookiesKey) as? [[String: Any]] else {
            return completionHandler(nil)
        }

        let cookies = cookiesProperties.compactMap { properties -> HTTPCookie? in
            let properties = Dictionary(uniqueKeysWithValues: properties.map { (HTTPCookiePropertyKey(rawValue: $0.key), $0.value) })
            return HTTPCookie(properties: properties)
        }

        completionHandler(cookies)
    }

    public override func storeCookies(_ newCookies: [HTTPCookie], for task: URLSessionTask) {
        getCookiesFor(task) { oldCookies in
            let cookies = (oldCookies ?? []) + newCookies
            let cookiesProperties = cookies.map { cookie in
                Dictionary(uniqueKeysWithValues: cookie.properties?.map { ($0.key.rawValue, $0.value) } ?? [])
            }

            self.defaults?.set(cookiesProperties, forKey: self.cookiesKey)
        }
    }
}
